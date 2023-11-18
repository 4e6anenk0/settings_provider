import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import '../../settings_provider.dart';

class Config<T extends SingleChildWidget> extends StatefulWidget {
  const Config({
    super.key,
    required this.child,
    required this.providers,
  });

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

  List<T> _getInitedConfigs() {
    List<T> initedProviders = [];
    for (T provider in providers) {
      var checkObject = provider as ConfigProvider;
      if (checkObject.config.isInited) {
        initedProviders.add(provider);
      }
    }
    return initedProviders;
  }

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

  final Widget child;

  final List<T> providers;

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState<T extends SingleChildWidget> extends State<Config<T>> {
  late List<T> _providers;

  @override
  void initState() {
    super.initState();
    _providers = widget._getInitedConfigs();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSettings(providers: _providers, child: widget.child);
  }
}
