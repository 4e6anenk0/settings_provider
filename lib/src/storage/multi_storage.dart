import 'dart:async';

import 'storage_interface.dart';

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

  /// Метод который не вызывает исключения для повторной инициализации хранилищ
  /// настроек. Это необходимо для выполнения в фоне, если первая инициализация не
  /// удалась
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

  /// вспомогательный метод, для инициализации хранилища без вызовов исключений.
  /// Исключение появляется в случае отсуцтвия реализации выбросом UnimplementedError
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

  /// Метод инициализации. Позволяет инициализировать все хранилища которое
  /// находятся в переменной _storages. Обработка исключений необходимо для
  /// того, чтобы программа работала беспрепятсвенно. Логика за обработку
  /// всех возможных исключений лежит на клиентском коде. Данная библиотека не
  /// обрабатывает исключения. Она лишь сохраняет список адресов списка для повторного
  /// вызова инициализации
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
