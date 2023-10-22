import 'package:flutter/widgets.dart';
import 'package:settings_provider/settings_provider.dart';
import 'package:settings_provider/src/helpers/settings_controller_interface.dart';
import 'package:settings_provider/src/settings_property.dart';

import 'config.dart';

class ConfigController implements ISettingsController {
  ConfigController._(this.configs);

  static Future<ConfigController> consist(
      {List<Config>? configs, bool usePrefix = true}) async {
    ConfigController controller = ConfigController._(configs);
    await controller._init();
    return controller;
  }

  late final List<Config>? configs;
  
  final Map<Enum, String> _mapEnumToString = {};
  final Map<String, Enum> _mapStringToEnum = {};
  final List<Property> _convertedScenarios = [];
  late final SettingsController _settingsController;

  Future<void> _init() async {
    if (scenarios != null) {
      _prepareConvertedScenarios(scenarios!);
      _settingsController =
          await SettingsController.consist(properties: _convertedScenarios);
    }
  }

  void _prepareConvertedScenarios(List<Scenario> scenarios) {
    for (Scenario scenario in scenarios) {
      for (Enum action in scenario.actions) {
        _mapEnumToString[action] = action.name;
        _mapStringToEnum[action.name] = action;
      }
      _convertedScenarios.add(Property(
          defaultValue: _mapEnumToString[scenario.defaultValue],
          id: scenario.defaultValue.runtimeType.toString()));
    }
  }

  @override
  T get<T>(Property<T> property) {
    if (_settingsController.data.data
        .containsValue(_mapEnumToString[property.defaultValue])) {
      String value = _settingsController.get(Property(
          defaultValue: _mapEnumToString[property.defaultValue]!,
          id: property.id));
      return _mapStringToEnum[value] as T;
    }
    return property.defaultValue;
  }

  @override
  Map<String, Object> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> match() {
    // TODO: implement match
    throw UnimplementedError();
  }

  @override
  Future<void> setForLocal<T>(Property property) {
    // TODO: implement setForLocal
    throw UnimplementedError();
  }

  @override
  void setForSession<T>(Property property) {
    // TODO: implement setForSession
  }

  @override
  Future<void> update<T>(Property<T> property) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
