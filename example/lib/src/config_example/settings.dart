import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

class GeneralConfig extends ConfigModel {
  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.general];

  @override
  List<BaseProperty> get properties =>
      [isDarkMode, counterScaler, name, themeMode];

  static Property<bool> isDarkMode = const Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: false,
  );

  static Property<int> counterScaler = const Property(
    defaultValue: 1,
    id: 'counterScaler',
    isLocalStored: false,
  );

  static Property<String> name = const Property(
    defaultValue: "John",
    id: 'name',
    isLocalStored: false,
  );

  static EnumProperty<ThemeMode> themeMode = const EnumProperty(
      id: 'themeMode',
      values: ThemeMode.values,
      defaultValue: ThemeMode.dark,
      isLocalStored: true);
}

class WebConfig extends ConfigModel {
  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.web];

  @override
  List<Property> get properties => [title];

  static Property<String> title = const Property(
    defaultValue: "It's Web App!",
    id: 'title',
    isLocalStored: false,
  );
}
