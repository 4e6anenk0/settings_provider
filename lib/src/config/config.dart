import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:settings_provider/src/scenarios/scenario.dart';
import 'package:settings_provider/src/settings_property.dart';

import '../helpers/settings_controller_interface.dart';
import 'config_property.dart';

class EmptyConfig extends ConfigModel {
  @override
  String get id => runtimeType.toString();

  @override
  List<ConfigPlatform> get platforms => [];

  @override
  List<Property> get properties => [];

  @override
  List<Scenario<Enum>>? get scenarios => [];
}

class ConfigsController {
  ConfigsController(configs) : _configs = configs;

  final Map<String, ConfigModel> _configs;

  ConfigModel getConfig(String id) {
    var config = _configs[id];
    return config ?? EmptyConfig();
  }
}

/* class Config {
  static T of<T extends ConfigModel>(BuildContext context,
      {bool listen = false}) {
    if (listen == true) {
      ConfigNotifier<T>? provider =
          context.dependOnInheritedWidgetOfExactType<ConfigNotifier<T>>();
      if (provider == null && null is! T) {
        throw Exception('Not founded provided Settings');
      }
      return provider?.notifier as T;
    } else {
      ConfigNotifier<T>? provider =
          context.getInheritedWidgetOfExactType<ConfigNotifier<T>>();
      if (provider == null && null is! T) {
        throw Exception('Not founded provided Settings');
      }
      return provider?.notifier as T;
    }
  }

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

  static final Map<String, ConfigModel> _configs = {};
  static final ConfigPlatform platform = _getConfigPlatform();

  static void register(List<ConfigModel> configs) {
    for (ConfigModel config in configs) {
      if (config.platforms.contains(platform) ||
          config.platforms.contains(ConfigPlatform.general)) {
        _configs[config.id] = config;
      }
    }
  }

  static void registerAnyway(List<ConfigModel> configs) {
    for (ConfigModel config in configs) {
      _configs[config.id] = config;
    }
  }

  static ConfigModel getConfig(String id) {
    return _configs[id] ?? EmptyConfig();
  }

  static List<ConfigModel> getAllConfigs() {
    return _configs.values.toList();
  }

  static Future<void> init() async {
    if (_configs.isNotEmpty) {
      await Future.wait(_configs.values.map((config) => config.init()));
    } else {
      throw Exception("Missing configurations for target platform.");
    }
  }
} */

/// A class that inherits `InheritedNotifier`
/// and serves only to implement `SettingsModel` in the context
class ConfigNotifier<T extends ConfigModel> extends InheritedNotifier<T> {
  const ConfigNotifier({
    super.key,
    required super.child,
    required T super.notifier,
  });
}

class ConfigProvider<T extends ConfigModel> extends SingleChildStatefulWidget {
  const ConfigProvider({required this.config, super.key});

  final T config;

  @override
  State<ConfigProvider<T>> createState() => _SettingsProviderState<T>();
}

class _SettingsProviderState<T extends ConfigModel>
    extends SingleChildState<ConfigProvider<T>> {
/*   late final T model = widget.config;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  } */

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ConfigNotifier(notifier: widget.config, child: child!);
  }
}
