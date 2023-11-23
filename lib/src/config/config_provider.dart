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

  List<T> _getInitedSettingsProviders() {
    List<T> initedProviders = [];
    for (T provider in providers) {
      var checkObject = provider as SettingsProvider<ConfigModel>;
      if (checkObject.model.isInited) {
        initedProviders.add(provider);
      }
    }
    return initedProviders;
  }

  /// The static `of()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// The `listen = true` option allows you to subscribe to changes in settings.
  /// But we should use the method with this parameter only in the context of the widget tree
  /// or in the `didChangeDependencies()` method.
  @Deprecated(
      'This method was split into two separate methods. For listening: `listenFrom()`, and for unsubscribed access `from()`.')
  static T of<T extends BaseSettingsModel>(BuildContext context,
      {bool listen = false}) {
    if (listen == true) {
      SettingsNotifier<T>? provider =
          context.dependOnInheritedWidgetOfExactType<SettingsNotifier<T>>();
      if (provider == null && null is! T) {
        throw Exception('Not founded provided Settings');
      }
      return provider?.notifier as T;
    } else {
      SettingsNotifier<T>? provider =
          context.getInheritedWidgetOfExactType<SettingsNotifier<T>>();
      if (provider == null && null is! T) {
        throw Exception('Not founded provided Settings');
      }
      return provider?.notifier as T;
    }
  }

  /// The static `listenFrom()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// This method allows you to subscribe to changes in settings.
  /// But we should use the method with this parameter only in the context of the widget tree
  /// or in the `didChangeDependencies()` method.
  static T listenFrom<T extends BaseSettingsModel>(BuildContext context) {
    SettingsNotifier<T>? provider =
        context.dependOnInheritedWidgetOfExactType<SettingsNotifier<T>>();
    if (provider == null && null is! T) {
      throw Exception('Not founded provided Settings');
    }
    return provider?.notifier as T;
  }

  /// The static `from()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// This method allows you to get setting from settings.
  static T from<T extends BaseSettingsModel>(BuildContext context) {
    SettingsNotifier<T>? provider =
        context.getInheritedWidgetOfExactType<SettingsNotifier<T>>();
    if (provider == null && null is! T) {
      throw Exception('Not founded provided Settings');
    }
    return provider?.notifier as T;
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
    _providers = widget._getInitedSettingsProviders();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSettings(providers: _providers, child: widget.child);
  }
}
