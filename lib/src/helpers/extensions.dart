import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

extension SettingsContextHelper on BuildContext {
  T setting<T extends BaseSettingsModel>() {
    return Settings.from<T>(this);
  }

  T listenSetting<T extends BaseSettingsModel>() {
    return Settings.listenFrom<T>(this);
  }
}
