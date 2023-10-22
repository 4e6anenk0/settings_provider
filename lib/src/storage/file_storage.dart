import 'storage_interface.dart';

class FileStorage implements ISettingsStorage {
  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  T? getSetting<T>(String id, Object defaultValue) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  bool isContains(String id) {
    // TODO: implement isContains
    throw UnimplementedError();
  }

  @override
  Future<void> removeSetting(String id) {
    // TODO: implement removeSetting
    throw UnimplementedError();
  }

  @override
  Future<void> setSetting(String id, Object value) {
    // TODO: implement setSetting
    throw UnimplementedError();
  }
}
