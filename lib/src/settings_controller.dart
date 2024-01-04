import 'dart:collection';

import 'helpers/exceptions.dart';
import 'helpers/settings_controller_interface.dart';
import 'properties/base/property.dart';
import 'property_converter.dart';
import 'storage/multi_storage.dart';
import 'storage/single_storage.dart';
import 'storage/sp_storage.dart';
import 'helpers/storage_interface.dart';

/// A controller that allows you to manage immutable settings configuration
class SettingsController implements ISettingsController {
  SettingsController._(
    this.properties, {
    String? prefix,
    required PropertyConverter converter,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  })  : _isDebug = isDebug,
        _converter = converter,
        _prefix = prefix,
        _storages = storages ?? [SharedPrefStorage()];

  /// Non consist controller
  factory SettingsController.nonconsist({
    required List<BaseProperty> properties,
    String? prefix,
    required PropertyConverter converter,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  }) {
    SettingsController controller = SettingsController._(
      properties,
      prefix: prefix,
      converter: converter,
      isDebug: isDebug,
      storages: storages,
    );
    controller._init();

    return controller;
  }

  /// Lazy controller. Need to init controller late
  factory SettingsController.lazy({
    List<BaseProperty>? properties,
    String? prefix,
    required PropertyConverter converter,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  }) {
    SettingsController controller = SettingsController._(
      properties,
      prefix: prefix,
      converter: converter,
      isDebug: isDebug,
      storages: storages,
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
    required PropertyConverter converter,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  }) async {
    SettingsController controller = SettingsController._(
      properties,
      prefix: prefix,
      converter: converter,
      isDebug: isDebug,
      storages: storages,
    );
    await controller._init();
    return controller;
  }

  final PropertyConverter _converter;

  /// List of all repositories to save settings.
  final List<ISettingsStorage> _storages;

  /// A class that handles a single repository or multiple repositories.
  late final ISettingsStorage settingsStorage;

  /// Flag to check initialization status. Required for lazy initialization cases.
  bool _isInited = false;
  bool get isInited => _isInited;

  /// A set of properties that are declarative descriptions of settings parameters.
  final List<BaseProperty>? properties;

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
  final HashMap<String, Object> _sessionSettings = HashMap();

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
    _setPrefixIfExist();

    settingsStorage = _getSettingsStorage(_storages);
    await settingsStorage.init();

    if (_isDebug) {
      settingsStorage.clear();
    }

    _keysMap[_snapshot.id] = _name(_snapshot.id);

    if (properties != null) {
      _adaptingProperties(properties!);
      if (settingsStorage.isContains(_keysMap[_snapshot.id]!)) {
        List<String> snapshotData = settingsStorage.getSetting(
            _keysMap[_snapshot.id]!, _snapshot.defaultValue);
        _snapshot = _snapshot.copyWith(defaultValue: snapshotData);
      }
      await _initSettingsMap(_adaptedProperties);
    }
    _isInited = true;
  }

  ISettingsStorage _getSettingsStorage(List<ISettingsStorage> storages) {
    if (storages.length == 1) {
      return SingleSettingsStorage(storages.first);
    } else if (storages.isEmpty) {
      return SingleSettingsStorage(SharedPrefStorage());
    } else {
      return MultiSettingsStorage(storages: storages);
    }
  }

  void _adaptingProperties(List<BaseProperty> properties) {
    for (BaseProperty property in properties) {
      _adaptedProperties.add(_converter.convertTo(property));
    }
  }

  void updateSettings() async {
    var snapshotData = settingsStorage.getSetting(
        _keysMap[_snapshot.id]!, _snapshot.defaultValue);
    _snapshot = _snapshot.copyWith(defaultValue: snapshotData);
    await _initSettingsMap(_adaptedProperties);
  }

  late String Function(String name) _name;

  void _setPrefixIfExist() {
    if (_prefix == null) {
      _name = (name) => name;
    } else {
      _name = (name) => "$_prefix$name";
    }
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

      _keysMap[property.id] = _name(property.id);

      if (property.isLocalStored) {
        if (_snapshot.defaultValue.isEmpty) {
          _initSetting(property);
        } else {
          if (_snapshot.defaultValue.contains(_keysMap[property.id])) {
            _restoreSetting(property);
          } else {
            _initSetting(property);
          }
        }
      } else {
        _sessionSettings[property.id] = property.defaultValue;
      }
    }

    await clearCache();

    await _makeSettingsSnapshot(properties);
  }

  /// Method to restore data from local storage
  void _restoreSetting(Property property) {
    var value = settingsStorage.getSetting(
        _keysMap[property.id] ?? _name(property.id), property.defaultValue);
    _sessionSettings[property.id] = value;
  }

  /// Method for setting data to local storage
  Future<void> _initSetting(Property property) async {
    await settingsStorage.setSetting(
        _keysMap[property.id] ?? _name(property.id), property.defaultValue);
    _sessionSettings[property.id] = property.defaultValue;
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
    await settingsStorage.setSetting(
        _keysMap[snapshotProperty.id]!, snapshotProperty.defaultValue);
  }

  /// A method that helps to remove settings that are not in the
  /// current list of propertyes and clear unused keys dump
  Future<void> clearCache() async {
    if (settingsStorage.isContains(_keysMap[_snapshot.id]!)) {
      // if the snapshot already exists, we get it
      List<String> snapshot = settingsStorage.getSetting(
          _keysMap[_snapshot.id]!, _snapshot.defaultValue);

      Future.forEach(snapshot, (key) {
        // if the key is in the list of current keys,
        // then there is no need to delete in settings, it is still actuality
        if (!_keysMap.containsKey(key)) {
          Future.value(settingsStorage.removeSetting(key));
        }
      });
    }
  }

  @override
  Future<void> update<T>(BaseProperty property) async {
    if (_sessionSettings.containsKey(property.id)) {
      var adaptedProperty = _converter.convertTo(property);
      _sessionSettings[adaptedProperty.id] = adaptedProperty.defaultValue;
      if (property.isLocalStored) {
        await settingsStorage.setSetting(
            _keysMap[adaptedProperty.id]!, adaptedProperty.defaultValue);
      }
    }
  }

  @override
  void setForSession<T>(BaseProperty property) {
    String key = property.id;
    if (_sessionSettings.containsKey(key)) {
      var adaptedProperty = _converter.convertTo(property);
      _sessionSettings[key] = adaptedProperty.defaultValue;
    }
  }

  @override
  Future<void> setForLocal<T>(BaseProperty property) async {
    if (property.isLocalStored) {
      var adaptedProperty = _converter.convertTo(property);
      await settingsStorage.setSetting(
          _keysMap[adaptedProperty.id]!, adaptedProperty.defaultValue);
    }
  }

  @override
  Future<void> match() async {
    if (properties != null) {
      for (Property property in _adaptedProperties) {
        if (property.isLocalStored &&
            _sessionSettings.containsKey(property.id)) {
          var needToStoreValue = _sessionSettings[property.id];
          await settingsStorage.setSetting(
              _keysMap[property.id]!, needToStoreValue!);
        }
      }
    }
  }

  @override
  Map<String, Object> getAll() {
    return _sessionSettings;
  }

  @override
  T get<T>(BaseProperty<T> property) {
    if (_sessionSettings.containsKey(property.id)) {
      var value = _sessionSettings[property.id];
      return _converter.convertValue(value, property);
    } else {
      return property.defaultValue;
    }
  }
}
