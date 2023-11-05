import 'dart:io';
import 'package:flutter/foundation.dart';

import '../helpers/exceptions.dart';
import 'config_property.dart';

class Config {
  static final Map<String, ConfigModel> _configs = {};
  static final ConfigPlatform platform = _getConfigPlatform();

  static ConfigPlatform _getConfigPlatform() {
    if (kIsWeb) {
      return ConfigPlatform.web;
    } else {
      switch (Platform.operatingSystem) {
        case 'ios':
          return ConfigPlatform.ios;
        case 'android':
          return ConfigPlatform.android;
        case 'macos':
          return ConfigPlatform.macos;
        case 'linux':
          return ConfigPlatform.linux;
        case 'windows':
          return ConfigPlatform.windows;
      }
    }
    return ConfigPlatform.general;
  }

  static void register(ConfigModel config) {
    if (config.platforms.contains(platform) ||
        config.platforms.contains(ConfigPlatform.general)) {
      _configs[config.id] = config;
    }
  }

  static void registerAll(List<ConfigModel> configs) {
    for (ConfigModel config in configs) {
      if (config.platforms.contains(platform) ||
          config.platforms.contains(ConfigPlatform.general)) {
        _configs[config.id] = config;
      }
    }
  }

  static ConfigModel? getConfig(String id) {
    return _configs[id];
  }

  static List<ConfigModel> getAllConfigs() {
    return _configs.values.toList();
  }

  static Future<void> init() async {
    if (_configs.isNotEmpty) {
      await Future.wait(_configs.values.map((config) => config.init()));
    } else {
      throw EmptyTargetConfigs("Missing configurations for target platform.");
    }
  }
}
