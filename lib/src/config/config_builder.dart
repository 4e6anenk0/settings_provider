import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import '../../settings_provider.dart';

class ConfigBuilder<T extends SingleChildWidget> extends StatefulWidget {
  const ConfigBuilder({
    super.key,
    required this.builder,
    required this.providers,
  });

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

  final Widget Function(BuildContext context, ConfigPlatform platform) builder;

  final List<T> providers;

  @override
  State<ConfigBuilder> createState() => _ConfigState();
}

class _ConfigState<T extends SingleChildWidget>
    extends State<ConfigBuilder<T>> {
  late List<T> _providers;

  @override
  void initState() {
    super.initState();
    _providers = widget._getInitedSettingsProviders();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSettings(
        providers: _providers, child: widget.builder(context, Config.platform));
  }
}
