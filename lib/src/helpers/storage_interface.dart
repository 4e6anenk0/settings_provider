abstract interface class ISettingsStorage {
  Future<void> init();
  T? getSetting<T>(String id, Object defaultValue);
  Future<void> setSetting(String id, Object value);
  Future<void> removeSetting(String id);
  Future<void> clear();
  //Future<void> removeByKey(String key);
  bool isContains(String id);
}
