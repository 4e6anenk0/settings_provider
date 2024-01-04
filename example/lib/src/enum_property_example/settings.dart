import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

class GeneralSettings extends SettingsModel {
  @override
  List<BaseProperty> get properties => [isDarkMode, counterScaler, themeMode];

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: false,
  );

  static const Property<int> counterScaler =
      Property(defaultValue: 1, id: 'counterScaler');

  static EnumProperty<ThemeMode> themeMode = const EnumProperty(
      id: 'themeMode',
      values: ThemeMode.values,
      defaultValue: ThemeMode.dark,
      isLocalStored: true);
}
