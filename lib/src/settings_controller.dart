import 'dart:collection';

import 'helpers/settings_controller_interface.dart';
import 'settings_property.dart';
import 'storage/multi_storage.dart';
import 'storage/single_storage.dart';
import 'storage/sp_storage.dart';
import 'helpers/storage_interface.dart';

/// A controller that allows you to manage immutable settings configuration
class SettingsController implements ISettingsController {
  SettingsController._(
    this.properties, {
    String? prefix,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  })  : _isDebug = isDebug,
        _prefix = prefix,
        _storages = storages ?? [SharedPrefStorage()];

  /// Non consist controller
  factory SettingsController.nonconsist({
    required List<Property> properties,
    String? prefix,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  }) {
    SettingsController controller = SettingsController._(properties,
        prefix: prefix, isDebug: isDebug, storages: storages);
    controller._init();

    return controller;
  }

  /// Lazy controller. Need to init controller late
  factory SettingsController.lazy({
    required List<Property> properties,
    String? prefix,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  }) {
    SettingsController controller = SettingsController._(properties,
        prefix: prefix, isDebug: isDebug, storages: storages);
    return controller;
  }

  /// A static method that allows you to create and initialize a controller asynchronously.
  ///
  /// This will allow you to get the data stored in SharedPreferences,
  /// but may cause a delay, for example, if there is a lot of data.
  ///
  /// `SettingsController.consist()` must be used in an asynchronous function.
  static Future<SettingsController> consist({
    List<Property>? properties,
    String? prefix,
    bool isDebug = false,
    List<ISettingsStorage>? storages,
  }) async {
    SettingsController controller = SettingsController._(properties,
        prefix: prefix, isDebug: isDebug, storages: storages);
    await controller._init();
    return controller;
  }

  /// List of all repositories to save settings.
  final List<ISettingsStorage> _storages;

  /// A class that handles a single repository or multiple repositories.
  late final ISettingsStorage settingsStorage;

  /// Flag to check initialization status. Required for lazy initialization cases.
  bool _isInited = false;
  bool get isInited => _isInited;

  /// A set of properties that are declarative descriptions of settings parameters.
  late final List<Property>? properties;

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
      if (settingsStorage.isContains(_keysMap[_snapshot.id]!)) {
        List<String> snapshotData = settingsStorage.getSetting(
            _keysMap[_snapshot.id]!, _snapshot.defaultValue);
        _snapshot = _snapshot.copyWith(defaultValue: snapshotData);
      }
      await _initSettingsMap(properties!);
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

  void updateSettings() async {
    var snapshotData = settingsStorage.getSetting(
        _keysMap[_snapshot.id]!, _snapshot.defaultValue);
    _snapshot = _snapshot.copyWith(defaultValue: snapshotData);
    await _initSettingsMap(properties!);
  }

  late String Function(String name) _name;

  void _setPrefixIfExist() {
    if (_prefix == null) {
      _name = (name) => name;
    } else {
      _name = (name) => "$_prefix$name";
    }
  }

  Future<void> _initSettingsMap(List<Property> properties) async {
    for (Property property in properties) {
      var name = _name(property.id);

      _keysMap[property.id] = name;

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

    // create a new snapshot
    await _makeSettingsSnapshot(properties);
  }

  /// Method to restore data from local storage
  Future<void> _restoreSetting(Property property) async {
    var value = await settingsStorage.getSetting(
        _keysMap[property.id]!, property.defaultValue);
    _sessionSettings[property.id] = value;
  }

  /// Method for setting data to local storage
  Future<void> _initSetting(Property property) async {
    await settingsStorage.setSetting(
        _keysMap[property.id]!, property.defaultValue);
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
        if (_keysMap.containsValue(key)) {
          // nothing to do
        } else {
          // remove setting from sp
          //_sessionSettings.remove(key);
          Future.value(settingsStorage.removeSetting(key));
        }
      });
    }
  }

  /// A method that helps to update data from the property.
  ///
  /// The data is updated both in the local storage and in the copy of the data
  /// of the current session.
  @override
  Future<void> update<T>(Property property) async {
    if (_sessionSettings.containsKey(property.id)) {
      _sessionSettings[property.id] = property.defaultValue;
      if (property.isLocalStored) {
        await settingsStorage.setSetting(
            _keysMap[property.id]!, property.defaultValue);
      }
    }
  }

  @override
  void setForSession<T>(Property property) {
    String key = property.id;
    if (_sessionSettings.containsKey(key)) {
      _sessionSettings[key] = property.defaultValue;
    }
  }

  @override
  Future<void> setForLocal<T>(Property property) async {
    if (property.isLocalStored) {
      await settingsStorage.setSetting(
          _keysMap[property.id]!, property.defaultValue);
    }
  }

  @override
  Future<void> match() async {
    if (properties != null) {
      for (Property property in properties!) {
        if (property.isLocalStored &&
            _sessionSettings.containsKey(property.id)) {
          var needToStoreValue = _sessionSettings[property.id];
          await settingsStorage.setSetting(
              _keysMap[property.id]!, needToStoreValue!);
        }
      }
    }
  }

  /// A method for obtaining the Map object of all settings of the current session.
  @override
  Map<String, Object> getAll() {
    return _sessionSettings;
  }

  /// A method that helps to get data from a property.
  ///
  /// First, the presence of data in the SettingsData object is checked.
  /// If there is no data in SettingsData for some reason,
  /// then the data is obtained either from the local storage or the default value
  /// is returned from the property.
  @override
  T get<T>(Property<T> property) {
    // get from SettingsData object
    if (_sessionSettings.containsKey(property.id)) {
      return _sessionSettings[property.id] as T;
      // get from local store
    } else if (property.isLocalStored) {
      T value = settingsStorage.getSetting(
          _keysMap[property.id]!, property.defaultValue as Object);
      // if exist return, else return default value
      return value ?? property.defaultValue;
    } else {
      // default
      return property.defaultValue;
    }
  }
}
