import 'dart:async';

import '../storage_interface.dart';

class MultiSettingsStorage implements IStorageWorker {
  MultiSettingsStorage({
    required List<ISettingsStorage> storages,
  }) {
    assert(storages.whereType<MultiSettingsStorage>().isEmpty,
        "Cannot add MultiSettingsStorage to the storages list.");
    _storages = storages;
  }

  late final List<ISettingsStorage> _storages;

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
  FutureOr<T?> getSetting<T>(String id, Object defaultValue) async {
    for (ISettingsStorage storage in _storages) {
      FutureOr<T?> setting = await storage.getSetting(id, defaultValue);
      if (setting != null) {
        return setting;
      }
    }
    return null;
  }

  @override
  FutureOr<bool> isContains(String id) async {
    for (ISettingsStorage storage in _storages) {
      if (await storage.isContains(id)) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> removeSetting(String id) async {
    await Future.wait(_storages.map((storage) => storage.removeSetting(id)));
    return true;
  }

  @override
  Future<bool> setSetting(String id, Object value) async {
    /* await Future.wait(
        _storages.map((storage) => storage.setSetting(id, value))); */

    for (ISettingsStorage storage in _storages) {
      await storage.setSetting(id, value);
    }

    return true;
  }
}
