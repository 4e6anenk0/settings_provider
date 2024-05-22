import 'dart:async';
import 'package:flutter/material.dart';

import '../../settings_provider.dart';
import '../helpers/exceptions.dart';
import '../interfaces/settings_controller_interface.dart';
import '../property_converter.dart';
import '../storages/storage.dart';

enum ConfigPlatform {
  ios,
  android,
  macos,
  linux,
  windows,
  web,
  general,
}

abstract class ConfigModel extends BaseSettingsModel {
  List<BaseProperty> get properties;
  List<ThemeDesc>? get themes => null;
  List<ConfigPlatform> get platforms;
  List<ISettingsStorage>? get storages => null;
  String get id => runtimeType.toString();
  ThemeProperty<ThemeDesc>? get defaultTheme => null;

  @override
  PropertyConverter get converter => _converter;

  @override
  ISettingsController get controller => _controller;

  @override
  SettingsStorage get storage => _storage;

  late final SettingsController _controller;
  final PropertyConverter _converter = PropertyConverter();
  final SettingsStorage _storage = SettingsStorage.getInstance();

  bool _isInited = false;
  bool get isInited => _isInited;

  @override
  ThemeProperty<ThemeDesc> get theme =>
      defaultTheme ??
      ThemeProperty(
        defaultValue: ThemeDesc(
          lightTheme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeID: 'defaultTheme',
        ),
        id: 'defaultTheme',
        isLocalStored: true,
      );

  /// A method that checks whether the list of target platforms
  /// has a generic destination type (for all platforms) or a specific destination type
  bool _isCorrectPlatform() {
    if (platforms.contains(ConfigPlatform.general) ||
        platforms.contains(Config.platform)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> init() async {
    if (_isCorrectPlatform()) {
      try {
        if (_storage.isNotInited) {
          await _storage.init();
        }

        if (themes != null) {
          //print("Seting the themes");
          for (ThemeDesc themeDesc in themes!) {
            converter.preset(
                targetProperty: theme, id: themeDesc.themeID, data: themeDesc);
          }
        }

        _controller = await SettingsController.consist(
            properties: properties,
            prefix: id,
            storages: storages,
            converter: _converter);

        _isInited = true;
      } catch (e) {
        throw InitializationError(model: runtimeType.toString());
      }
    }
  }

  @override
  T get<T>(BaseProperty<T> property) {
    return _controller.get(property);
  }

  @override
  Future<void> update<T>(BaseProperty<T> property) async {
    await _controller.update(property);
    notifyListeners();
  }

  @override
  Future<void> setForLocal<T>(BaseProperty property) async {
    await _controller.setForLocal(property);
  }

  @override
  void setForSession<T>(BaseProperty property) {
    _controller.setForSession(property);
    notifyListeners();
  }

  @override
  Future<void> match() async {
    await _controller.match();
  }

  @override
  Map<String, Object> getAll() {
    return _controller.getAll();
  }
}
