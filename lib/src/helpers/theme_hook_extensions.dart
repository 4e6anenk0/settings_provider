import 'package:flutter/material.dart';

import '../properties/theme/theme_property.dart';
import '../settings.dart';

extension SettingsHooksHelper on BuildContext {
  ThemeDesc theme<T extends BaseSettingsModel>() {
    var settingsObj = Settings.listenFrom<T>(this);
    return settingsObj.get(settingsObj.theme);
  }

  ThemeProperty themeProperty<T extends BaseSettingsModel>() {
    return Settings.from<T>(this).theme;
  }

  Future<void> switchTheme<T extends BaseSettingsModel>(ThemeDesc theme) async {
    var settingObj = Settings.from<T>(this);
    await settingObj.update(settingObj.theme.copyWith(defaultValue: theme));
  }
}
