import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

extension SettingsContextHelper on BuildContext {
  T config<T extends ConfigModel>() {
    return Config.of<T>(this);
  }

  T listenConfig<T extends ConfigModel>() {
    return Config.of<T>(this, listen: true);
  }

  T setting<T extends SettingsModel>() {
    return Settings.of(this);
  }

  T listenSetting<T extends SettingsModel>() {
    return Settings.of(this, listen: true);
  }
}
