import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import '../../settings_provider.dart';

/// ConfigBuilder allows you to build a tree of widgets depending
/// on the target platform on which the app is launched
class ConfigBuilder<T extends SingleChildWidget> extends StatefulWidget {
  const ConfigBuilder({
    super.key,
    required this.builder,
    required this.configs,
  });

  /// A method that allocates initialized settings models for the target platform
  List<T> _getInitializedSettingsProviders() {
    List<T> initializedProviders = [];
    for (T provider in configs) {
      var checkObject = provider as SettingsProvider<ConfigModel>;
      if (checkObject.model.isInitialized) {
        initializedProviders.add(provider);
      }
    }
    return initializedProviders;
  }

  final Widget Function(BuildContext context, ConfigPlatform platform) builder;

  final List<T> configs;

  @override
  State<ConfigBuilder> createState() => _ConfigState();
}

class _ConfigState<T extends SingleChildWidget>
    extends State<ConfigBuilder<T>> {
  late List<T> _providers;

  @override
  void initState() {
    super.initState();
    _providers = widget._getInitializedSettingsProviders();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSettings(
        providers: _providers, child: widget.builder(context, Config.platform));
  }
}
