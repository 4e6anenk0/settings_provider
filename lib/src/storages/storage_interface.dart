import 'dart:async';

abstract interface class ISettingsStorage {
  Future<void> init();
  FutureOr<T?> getSetting<T>(String id, Object defaultValue);
  Future<bool> setSetting(String id, Object value);
  Future<bool> removeSetting(String id);
  Future<void> clear();
  FutureOr<bool> isContains(String id);
}

abstract interface class IStorageWorker {
  FutureOr<T?> getSetting<T>(String id, Object defaultValue);
  Future<bool> setSetting(String id, Object value);
  Future<bool> removeSetting(String id);
  Future<void> clear();
  FutureOr<bool> isContains(String id);
}
