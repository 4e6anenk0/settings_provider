import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/storage_interface.dart';

class SharedPrefStorage implements ISettingsStorage {
  late SharedPreferences _storage;

  @override
  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
  }

  /// Helper function for getting data from Shared Preferences
  Function _getSharedPreferencesCallback(Type type) {
    if (type == bool) {
      return _storage.getBool;
    } else if (type == int) {
      return _storage.getInt;
    } else if (type == double) {
      return _storage.getDouble;
    } else if (type == String) {
      return _storage.getString;
    } else if (type == List<String>) {
      return _storage.getStringList;
    } else {
      throw Exception('''Not founded relevant type for callback function. 
          You cant get value from Shared Preferences''');
    }
  }

  /// Helper function for setting data in Shared Preferences
  Function _setSharedPreferencesCallback(Type type) {
    if (type == bool) {
      return _storage.setBool;
    } else if (type == int) {
      return _storage.setInt;
    } else if (type == double) {
      return _storage.setDouble;
    } else if (type == String) {
      return _storage.setString;
    } else if (type == List<String>) {
      return _storage.setStringList;
    } else {
      throw Exception('''Not founded relevant type for callback function. 
      You cant set value to Shared Preferences''');
    }
  }

  @override
  T? getSetting<T>(String id, Object defaultValue) {
    Function callback = _getSharedPreferencesCallback(defaultValue.runtimeType);
    T? data = callback(id);
    return data;
  }

  @override
  Future<void> setSetting(String id, Object value) async {
    Function callback = _setSharedPreferencesCallback(value.runtimeType);
    await callback(id, value);
  }

  @override
  Future<void> removeSetting(String id) async {
    await _storage.remove(id);
  }

  @override
  bool isContains(String id) {
    bool isContains = _storage.containsKey(id);
    return isContains;
  }

  @override
  Future<void> clear() async {
    await _storage.clear();
  }
}
