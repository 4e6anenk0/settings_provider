import 'dart:async';

import 'helpers/exceptions.dart';
import 'interfaces/converter_interface.dart';
import 'interfaces/settings_controller_interface.dart';
import 'properties/base/property.dart';
import 'property_session.dart';
import 'storages/sp_storage.dart';
import 'interfaces/storage_interface.dart';
import 'storages/storage.dart';

/// A controller that allows you to manage immutable settings configuration
class SettingsController implements ISettingsController {
  SettingsController._({
    List<BaseProperty>? properties,
    String? prefix,
    required IPropertyConverter converter,
    List<ISettingsStorage>? storages,
    bool isDebug = false,
  })  : _properties = properties,
        _isDebug = isDebug,
        _converter = converter,
        _prefix = prefix,
        _storages = storages ?? [SharedPrefStorage()];

  /// Non consist controller
  factory SettingsController.nonconsist({
    List<BaseProperty>? properties,
    String? prefix,
    required IPropertyConverter converter,
    List<ISettingsStorage>? storages,
    bool isDebug = false,
  }) {
    SettingsController controller = SettingsController._(
      properties: properties,
      prefix: prefix,
      converter: converter,
      storages: storages,
      isDebug: isDebug,
    );

    controller._init();

    return controller;
  }

  /// Lazy controller. Need to init controller late
  factory SettingsController.lazy({
    List<BaseProperty>? properties,
    String? prefix,
    required IPropertyConverter converter,
    List<ISettingsStorage>? storages,
    bool isDebug = false,
  }) {
    SettingsController controller = SettingsController._(
      properties: properties,
      prefix: prefix,
      converter: converter,
      storages: storages,
      isDebug: isDebug,
    );

    return controller;
  }

  /// A static method that allows you to create and initialize a controller asynchronously.
  ///
  /// This will allow you to get the data stored in SharedPreferences,
  /// but may cause a delay, for example, if there is a lot of data.
  ///
  /// `SettingsController.consist()` must be used in an asynchronous function.
  static Future<SettingsController> consist({
    List<BaseProperty>? properties,
    String? prefix,
    required IPropertyConverter converter,
    List<ISettingsStorage>? storages,
    bool isDebug = false,
  }) async {
    SettingsController controller = SettingsController._(
      properties: properties,
      prefix: prefix,
      converter: converter,
      storages: storages,
      isDebug: isDebug,
    );

    await controller._init();

    return controller;
  }

  /// A converter is required to convert properties to the Property type
  final IPropertyConverter _converter;

  /// List of all repositories to save settings.
  final List<ISettingsStorage> _storages;

  /// A class that handles a single repository or multiple repositories.
  //late final ISettingsStorage settingsStorage;
  late final StorageOverlay _storage;

  /// Flag to check initialization status. Required for lazy initialization cases.
  bool _isInited = false;
  bool get isInited => _isInited;

  /// A set of properties that are declarative descriptions of settings parameters.
  final List<BaseProperty>? _properties;

  /// A list of converted properties to the Property type
  final List<Property> _adaptedProperties = [];

  /// Adds a prefix to the settings keys.
  ///
  /// This is necessary in order to be able to use settings in projects with an
  /// existing SharedPreference, so as not to overwrite the values of existing
  /// fields due to minimizing the probability of matching keys (names) of settings
  /// final bool _usePrefix;
  final String? _prefix;

  /// /// snapshot is used for initialization to analyze fields already saved
  /// in local storage and restore it, otherwise save new unsaved settings and
  /// remove the unnecessary ones.
  Property<List<String>> _snapshot =
      const Property(defaultValue: [], id: 'Snapshot', isLocalStored: true);

  /// utility parameter to initialize data
  /// with less overhead than directly modifying immutable data in `SettingData`
  // final Map<String, Object> _sessionSettings = {};
  //final HashMap<String, Object> _sessionSettings = HashMap();

  final PropertySession _session = PropertySession();

  /// A utility parameter for aggregating new keys that represent
  /// the future view of the _snapshot parameter.
  ///
  /// You can think of this as a data dump of the current list of configuration options.
  /// And _snapshot is a dump of the previous configuration options. The key parameters
  /// are defined through the id parameter in the properties
  final Map<String, String> _keysMap = {};

  final bool _isDebug;

  Future<void> init() async {
    if (!_isInited) {
      await _init();
    }
  }

  Future<void> _init() async {
    _storage =
        StorageOverlay(storages: _storages, prefix: _prefix, bind: Property);

    if (_isDebug) {
      _storage.clear();
    }

    if (_properties != null) {
      _storage.makePrefixedKeysDump(_properties!);
      _storage.makePrefixedKeyDump(_snapshot);

      _adaptingProperties(_properties!);

      if (await _storage.isContains(_snapshot.id)) {
        List<String> snapshotData =
            await _storage.getSetting(_snapshot.id, _snapshot.defaultValue);
        _snapshot = _snapshot.copyWith(defaultValue: snapshotData);
      }

      await _initSettingsMap(_adaptedProperties);
    }
    _isInited = true;
  }

  void _adaptingProperties(List<BaseProperty> properties) {
    for (BaseProperty property in properties) {
      _adaptedProperties.add(_converter.convertTo(property));
    }
  }

  void updateSettings() async {
    var snapshotData =
        await _storage.getSetting(_snapshot.id, _snapshot.defaultValue);
    _snapshot = _snapshot.copyWith(defaultValue: snapshotData);
    await _initSettingsMap(_adaptedProperties);
  }

  bool isUniqueID(String id) {
    if (_keysMap.containsKey(id)) {
      return false;
    }
    return true;
  }

  Future<void> _initSettingsMap(List<Property> properties) async {
    for (Property property in properties) {
      if (!isUniqueID(property.id)) {
        throw NotUniqueIdExeption(
            "A non-unique ID (${property.id}) in the property was passed",
            property.id);
      }

      _keysMap[property.id] =
          _storage.getPrefixedKey(property.id) ?? "$_prefix${property.id}";

      if (property.isLocalStored) {
        if (_snapshot.defaultValue.isEmpty) {
          await _initSetting(property);
        } else {
          if (_snapshot.defaultValue.contains(_keysMap[property.id])) {
            await _restoreSetting(property);
          } else {
            await _initSetting(property);
          }
        }
      } else {
        _session.set(property);
      }
    }

    await clearCache();

    await _makeSettingsSnapshot(properties);
  }

  /// Method to restore data from local storage
  FutureOr<void> _restoreSetting(Property property) async {
    var value = await _storage.getSetting(property.id, property.defaultValue);
    _session.setFromValue(value: value, id: property.id);
  }

  /// Method for setting data to local storage
  Future<void> _initSetting(Property property) async {
    await _storage.setSetting(property.id, property.defaultValue);
    _session.set(property);
  }

  /// Method to create a snapshot.
  ///
  /// The snapshot allows you to clear the local storage
  Future<void> _makeSettingsSnapshot(List<Property> propertyes) async {
    List<String> keysList = [];
    for (Property property in propertyes) {
      if (property.isLocalStored) {
        keysList.add(_keysMap[property.id]!);
      }
    }
    Property snapshotProperty = _snapshot.copyWith(defaultValue: keysList);
    await _storage.setSetting(
        snapshotProperty.id, snapshotProperty.defaultValue);
  }

  /// A method that helps to remove settings that are not in the
  /// current list of propertyes and clear unused keys dump
  Future<void> clearCache() async {
    if (await _storage.isContains(_snapshot.id)) {
      // if the snapshot already exists, we get it
      List<String> snapshot =
          await _storage.getSetting(_snapshot.id, _snapshot.defaultValue);

      Future.forEach(snapshot, (key) {
        // if the key is in the list of current keys,
        // then there is no need to delete in settings, it is still actuality
        if (!_keysMap.containsKey(key)) {
          Future.value(_storage.removeSetting(key));
        }
      });
    }
  }

  @override
  Future<void> update<T>(BaseProperty property) async {
    if (_session.contains(property)) {
      var adaptedProperty = _converter.convertTo(property);
      _session.set(adaptedProperty);
      if (property.isLocalStored) {
        await _storage.setSetting(
            adaptedProperty.id, adaptedProperty.defaultValue);
      }
    }
  }

  @override
  void setForSession<T>(BaseProperty property) {
    if (_session.contains(property)) {
      _session.set(_converter.convertTo(property));
    }
  }

  @override
  Future<void> setForLocal<T>(BaseProperty property) async {
    if (property.isLocalStored) {
      var adaptedProperty = _converter.convertTo(property);
      await _storage.setSetting(
          adaptedProperty.id, adaptedProperty.defaultValue);
    }
  }

  @override
  Future<void> match() async {
    if (_properties != null) {
      for (Property property in _adaptedProperties) {
        if (property.isLocalStored && _session.contains(property)) {
          var needToStoreValue = _session.get(property);
          await _storage.setSetting(property.id, needToStoreValue!);
        }
      }
    }
  }

  @override
  Map<String, Object> getAll() {
    return _session.settings;
  }

  @override
  T get<T>(BaseProperty<T> property) {
    if (_session.contains(property)) {
      var value = _session.get(property);
      return _converter.convertValue(value, property);
    } else {
      return property.defaultValue;
    }
  }
}
