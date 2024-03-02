import 'dart:async';
import 'dart:collection';

import '../properties/theme/theme_property.dart';
import '../interfaces/storage_interface.dart';
import '../properties/base/property.dart';
import '../properties/enum/enum_property.dart';
import 'workers/multi_storage_worker.dart';
import 'workers/single_storage_worker.dart';
import 'sp_storage.dart';

class SettingsStorage {
  SettingsStorage._();

  static final SettingsStorage _storage = SettingsStorage._();

  factory SettingsStorage.getInstance() {
    return _storage;
  }

  final Set<ISettingsStorage> _storages = {
    SharedPrefStorage(),
  };

  /// Dependencies of property types and storage that serve them are defined
  final Map<Type, List<Type>> _dependedTypes = {
    Property: [SharedPrefStorage],
    EnumProperty: [SharedPrefStorage],
    ThemeProperty: [SharedPrefStorage]
  };

  bool _isInited = false;
  bool get isInited => _isInited;
  bool get isNotInited => !_isInited;

  Future<void> init() async {
    await Future.wait(_storages.map((storage) => storage.init()));
    _isInited = true;
  }

  /// A method to set the property type's dependency on storage to store these properties.
  ///
  /// Can be used to register custom property types and storage types in the project.
  void registerDependency(Type typeOfProperty, List<Type> typesOfStorage) {
    assert(typeOfProperty is BaseProperty);
    if (isNotRegistered(typeOfProperty)) {
      _dependedTypes[typeOfProperty] = typesOfStorage;
    }
  }

  /// A method that helps determine whether dependencies are set for the
  /// corresponding type passed to this method
  bool isRegistered(Type typeOfProperty) {
    if (_dependedTypes.containsKey(typeOfProperty)) {
      return _dependedTypes[typeOfProperty]!.isNotEmpty;
    } else {
      return false;
    }
  }

  bool isNotRegistered(Type typeOfProperty) {
    if (_dependedTypes.containsKey(typeOfProperty)) {
      return _dependedTypes[typeOfProperty]!.isEmpty;
    } else {
      return true;
    }
  }

  void addStorage(ISettingsStorage storage) {
    _storages.add(storage);
  }

  void addStorages(List<ISettingsStorage> storages) {
    _storages.addAll(storages);
  }

  IStorageWorker getDependWorker(Type typeOfProperty) {
    var storageTypes = _dependedTypes[typeOfProperty];
    if (storageTypes != null) {
      return getWorker(storageTypes);
    } else {
      throw Exception([
        'There are no repositories matching the given type of poperty: ${typeOfProperty.toString()}.'
      ]);
    }
  }

  IStorageWorker getDefaultWorker() {
    return SingleSettingsStorage(
        _storages.firstWhere((storage) => storage is SharedPrefStorage));
  }

  IStorageWorker getWorker(List<Type> storageTypes) {
    Iterable<ISettingsStorage> neededStorages = _storages
        .where((element) => storageTypes.contains(element.runtimeType));

    if (neededStorages.length == 1) {
      return SingleSettingsStorage(neededStorages.first);
    } else if (neededStorages.isEmpty) {
      throw Exception([
        'There are no repositories matching the given types: ${storageTypes.toString()}.'
      ]);
    } else {
      return MultiSettingsStorage(storages: neededStorages.toList());
    }
  }

  ISettingsStorage? getStorage(Type typeOfStorage) {
    return _storages
        .firstWhere((storage) => storage.runtimeType == typeOfStorage);
  }
}

/// Keeps references to storages and helps work with signed storages via a worker.
/// Also adds the ability to work with prefixes to separate groups of settings
class StorageOverlay {
  StorageOverlay({
    List<ISettingsStorage>? storages,
    String? prefix,
    Type? bind,
  })  : _prefix = prefix,
        _bind = bind ?? Property {
    _setPrefixIfExist();
    _storageWorker = _storage.getDependWorker(_bind);
  }

  final SettingsStorage _storage = SettingsStorage.getInstance();
  late final IStorageWorker _storageWorker;

  final String? _prefix;

  final Type _bind;

  final HashMap<String, String> _keysDump = HashMap();

  late String Function(String name) _name;

  void _setPrefixIfExist() {
    if (_prefix == null) {
      _name = (name) => name;
    } else {
      _name = (name) => "$_prefix$name";
    }
  }

  bool isPrefixedKey(String key) {
    return _keysDump.containsKey(key);
  }

  bool isNotPrefixedKey(String key) {
    return !_keysDump.containsKey(key);
  }

  String prefixed(BaseProperty property) {
    if (!_keysDump.containsKey(property.id)) {
      var name = _name(property.id);
      _keysDump[property.id] = name;
      return name;
    }
    return _keysDump[property.id]!;
  }

  Future<void> clear() async {
    await _storageWorker.clear();
  }

  FutureOr<T?> getSetting<T>(String id, Object defaultValue) {
    return _storageWorker.getSetting(_keysDump[id] ?? _name(id), defaultValue);
  }

  FutureOr<bool> isContains(String id) {
    return _storageWorker.isContains(_keysDump[id] ?? _name(id));
  }

  Future<void> removeSetting(String id) async {
    await _storageWorker.removeSetting(_keysDump[id] ?? _name(id));
  }

  Future<void> setSetting(String id, Object value) async {
    await _storageWorker.setSetting(_keysDump[id] ?? _name(id), value);
  }
}
