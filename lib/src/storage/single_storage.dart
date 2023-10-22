import '../helpers/storage_interface.dart';

class SingleSettingsStorage implements ISettingsStorage {
  SingleSettingsStorage(ISettingsStorage storage) {
    assert(storage.runtimeType != SingleSettingsStorage,
        "Cannot add SingleSettingsStorage to the SingleSettingsStorage.");
    _storage = storage;
  }

  late final ISettingsStorage _storage;
  bool _isInited = false;
  bool get isInited => _isInited;

  ISettingsStorage getStorage() {
    return _storage;
  }

  @override
  Future<void> clear() async {
    await _storage.clear();
  }

  @override
  T? getSetting<T>(String id, Object defaultValue) {
    return _storage.getSetting(id, defaultValue);
  }

  @override
  Future<void> init() async {
    try {
      await _storage.init();
      _isInited = true;
    } on UnimplementedError {
      throw UnimplementedError('''
The init method was not implemented for the next storage: ${_storage.runtimeType}
        ''');
    }
  }

  Future<bool> reinitForNotInited() async {
    if (!_isInited) {
      try {
        await _storage.init();
        return true;
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  @override
  bool isContains(String id) {
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
