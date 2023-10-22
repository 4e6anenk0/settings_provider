import 'dart:async';

import '../helpers/storage_interface.dart';

class MultiSettingsStorage implements ISettingsStorage {
  MultiSettingsStorage({
    required List<ISettingsStorage> storages,
  }) {
    assert(storages.whereType<MultiSettingsStorage>().isEmpty,
        "Cannot add MultiSettingsStorage to the storages list.");
    _storages = storages;
  }

  late final List<ISettingsStorage> _storages;
  bool _isInited = false;
  bool get isInited => _isInited;

  final List<ISettingsStorage> _storagesWasNotInited = [];

  ISettingsStorage getStorage(int id) {
    return _storages[id];
  }

  List<ISettingsStorage> getAllStorages() {
    return _storages;
  }

  @override
  Future<void> clear() async {
    await Future.wait(_storages.map((storage) => storage.clear()));
  }

  @override
  T? getSetting<T>(String id, Object defaultValue) {
    for (ISettingsStorage storage in _storages) {
      T? setting = storage.getSetting(id, defaultValue);
      if (setting != null) {
        return setting;
      }
    }
    return null;
  }

  /// A method that doesn't trigger exceptions for reinitializing the settings storage.
  /// This is necessary for background execution if the initial initialization fails.
  Future<bool> reinitForNotInited({ISettingsStorage? storage}) async {
    if (storage != null && _storagesWasNotInited.contains(storage) == false) {
      return reinitStorage(storage);
    } else {
      for (ISettingsStorage storage in _storagesWasNotInited) {
        return reinitStorage(storage);
      }
    }
    return true;
  }

  /// A helper method for initializing the storage without throwing exceptions.
  /// An exception occurs if the implementation is missing, throwing an UnimplementedError.
  Future<bool> reinitStorage(ISettingsStorage storage) async {
    try {
      await storage.init();
      _storagesWasNotInited.remove(storage);
      return true;
    } on UnimplementedError {
      throw UnimplementedError('''
The init method was not implemented for the next storage: ${storage.runtimeType}
        ''');
    } catch (e) {
      return false;
    }
  }

  /// Initialization method. Allows initializing all storage present in the _storages variable.
  /// Exception handling is necessary to ensure the program runs smoothly. The logic for
  /// handling all possible exceptions lies in the client code. This library does not
  /// handle exceptions. It simply stores a list of addresses for re-initialization.
  @override
  Future<void> init() async {
    for (ISettingsStorage storage in _storages) {
      try {
        await storage.init();
      } on UnimplementedError {
        throw UnimplementedError('''
The init method was not implemented for the next storage: ${storage.runtimeType}
        ''');
      } catch (e) {
        //_storagesWasNotInited[storage.runtimeType] = storage.
        _storagesWasNotInited.add(storage);
        rethrow;
      }
    }
    _isInited = true;
  }

  @override
  bool isContains(String id) {
    for (ISettingsStorage storage in _storages) {
      if (storage.isContains(id)) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> removeSetting(String id) async {
    await Future.wait(_storages.map((storage) => storage.removeSetting(id)));
  }

  @override
  Future<void> setSetting(String id, Object value) async {
    await Future.wait(
        _storages.map((storage) => storage.setSetting(id, value)));
  }
}
