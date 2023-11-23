import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

class GeneralSettings extends SettingsModel {
  @override
  List<Property> get properties => [isDarkMode, counterScaler];

  @override
  List<Scenario<Enum>>? get scenarios => [themeMode];

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static const Property<int> counterScaler =
      Property(defaultValue: 1, id: 'counterScaler');

  static Scenario<ThemeMode> themeMode =
      Scenario(actions: ThemeMode.values, defaultValue: ThemeMode.dark);
}
