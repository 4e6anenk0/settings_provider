import 'package:flutter/widgets.dart';

import '../helpers/exceptions.dart';
import '../settings.dart';
import 'config.dart';
import 'config_property.dart';

class ConfigProvider extends StatefulWidget {
  const ConfigProvider({
    super.key,
    required this.child,
    this.configs,
  });

  final Widget child;

  final List<ConfigModel>? configs;

  @override
  State<ConfigProvider> createState() => _ConfigProviderState();
}

class _ConfigProviderState extends State<ConfigProvider> {
  late final List<ConfigModel> _configs;
  late final List<SettingsProvider> _providers;
  late final int _configLenght;

  _prepare() {
    if (widget.configs != null) {
      _configs = [];
      _configs.addAll(widget.configs!);
      _configLenght = _configs.length;
    } else {
      _configs = Config.getAllConfigs();
      _configLenght = _configs.length;
      if (_configLenght == 1) {
        return;
      } else if (_configLenght > 1) {
        for (ConfigModel config in _configs) {
          _providers.add(SettingsProvider(model: config));
        }
      } else {
        throw ConfigBuilderExeption("No config provided for this platform.");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (_configLenght == 1) {
          return Settings(
              settingsController: _configs.first.settingsController,
              scenarioController: _configs.first.scenarioController,
              child: widget.child);
        } else {
          return MultiSettings(providers: _providers, child: widget.child);
        }
      },
    );
  }
}
