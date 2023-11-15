import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import '../helpers/exceptions.dart';
import '../settings.dart';
import 'config.dart';
import 'config_property.dart';

class ConfigProvider<T extends ConfigModel> extends StatefulWidget {
  const ConfigProvider({
    super.key,
    required this.child,
    required this.providers,
    this.configs,
  });

  final Widget child;

  final List<T>? configs;

  final List<SingleChildWidget> providers;

  @override
  State<ConfigProvider> createState() => _ConfigProviderState();
}

class _ConfigProviderState extends State<ConfigProvider> {
  late final List<ConfigModel> _configs;
  //late final List<ConfigsProvider<ConfigModel>> _providers;
  //late final int _configLenght;

  _prepare() {}

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSettings(providers: widget.providers, child: widget.child);
  }
}
