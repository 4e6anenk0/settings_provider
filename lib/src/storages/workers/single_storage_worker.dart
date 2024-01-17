import 'dart:async';

import '../../interfaces/storage_interface.dart';

class SingleSettingsStorage implements IStorageWorker {
  SingleSettingsStorage(ISettingsStorage storage) {
    assert(storage.runtimeType != SingleSettingsStorage,
        "Cannot add SingleSettingsStorage to the SingleSettingsStorage.");
    _storage = storage;
  }

  late final ISettingsStorage _storage;

  ISettingsStorage getStorage() {
    return _storage;
  }

  @override
  Future<void> clear() async {
    await _storage.clear();
  }

  @override
  FutureOr<T?> getSetting<T>(String id, Object defaultValue) async {
    return await _storage.getSetting(id, defaultValue);
  }

  @override
  FutureOr<bool> isContains(String id) {
    return _storage.isContains(id);
  }

  @override
  Future<void> removeSetting(String id) async {
    await _storage.removeSetting(id);
  }

  @override
  Future<void> setSetting(String id, Object value) async {
    await _storage.setSetting(id, value);
  }
}
