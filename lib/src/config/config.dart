import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:settings_provider/src/config/config_provider.dart';

import '../helpers/exceptions.dart';

import 'config_property.dart';

class Config {
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
}

class Configurator {
  static final List<ConfigsProvider> providers = [];

  static void register(config) {
    providers.add(ConfigsProvider(model: config));
  }

  static init() async {
    if (providers.isNotEmpty) {
      await Future.wait(providers.map((provider) => provider.model.init()));
    } else {
      throw Exception("Missing configurations for target platform.");
    }
  }
}

class ConfigController {
  final Map<String, ConfigsProvider> _providers = {};
  late final ConfigPlatform platform = _getConfigPlatform();

  ConfigPlatform _getConfigPlatform() {
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

  void register<T extends ConfigModel>(T config) {
    if (config.platforms.contains(platform) ||
        config.platforms.contains(ConfigPlatform.general)) {
      _providers[config.id] = ConfigsProvider(model: config);
    }
  }

  void registerAll<T extends ConfigModel>(List<T> configs) {
    for (T config in configs) {
      if (config.platforms.contains(platform) ||
          config.platforms.contains(ConfigPlatform.general)) {
        _providers[config.id] = ConfigsProvider(model: config);
      }
    }
  }

  ConfigsProvider? getProvider(String id) {
    return _providers[id];
  }

  List<ConfigsProvider> getAllProviders<T>() {
    return _providers.values.toList();
  }

  Future<void> init() async {
    if (_providers.isNotEmpty) {
      await Future.wait(
          _providers.values.map((provider) => provider.model.init()));
    } else {
      throw EmptyTargetConfigs("Missing configurations for target platform.");
    }
  }
}

/// A class that inherits `InheritedNotifier`
/// and serves only to implement `SettingsModel` in the context
class ConfigNotifier<T extends ConfigModel> extends InheritedNotifier<T> {
  const ConfigNotifier({
    super.key,
    required super.child,
    required T super.notifier,
  });
}

class ConfigsProvider<T extends ConfigModel> extends SingleChildStatefulWidget {
  const ConfigsProvider({required this.model, super.key});

  /// A separate unique instance of the SettingsModel class that allows you
  /// to use SettingsController for a group of unique settings in the form of
  /// a separate SettingsData
  final T model;

  @override
  State<ConfigsProvider<T>> createState() => _SettingsProviderState<T>();
}

class _SettingsProviderState<T extends ConfigModel>
    extends SingleChildState<ConfigsProvider<T>> {
  late final T model = widget.model;

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ConfigNotifier(notifier: model, child: child!);
  }
}
