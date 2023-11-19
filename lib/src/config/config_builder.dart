/* import 'package:flutter/widgets.dart';

import '../helpers/exceptions.dart';
import '../settings.dart';
import 'config.dart';
import 'config_property.dart';

class ConfigBuilder extends StatefulWidget {
  const ConfigBuilder({
    super.key,
    required this.builder,
    required this.configController,
    this.configs,
  });

  final Widget Function(BuildContext context, ConfigPlatform platform) builder;

  final List<ConfigModel>? configs;

  final ConfigController configController;

  @override
  State<ConfigBuilder> createState() => _ConfigProviderState();
}

class _ConfigProviderState extends State<ConfigBuilder> {
  late final ConfigPlatform _platform;
  late final List<ConfigsProvider> _configs;
  late final List<ConfigsProvider> _providers;
  late final int _configLenght;

  _prepare() {
    _platform = widget.configController.platform;
    if (widget.configs != null) {
      _configs = [];
      _configs.addAll(widget.configs!);
      _configLenght = _configs.length;
    } else {
      _configs = widget.configController.getAllConfigs();
      _configLenght = _configs.length;
      if (_configLenght == 1) {
        return;
      } else if (_configLenght > 1) {
        _providers = [];
        for (ConfigModel config in _configs) {
          _providers.add(ConfigsProvider(model: config));
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
              child: widget.builder(context, _platform));
        } else {
          return MultiSettings(
              providers: _providers, child: widget.builder(context, _platform));
        }
      },
    );
  }
}

/* 
Widget build(BuildContext context) {
    return FutureBuilder(
      future: initConfig(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.waitingBuilder(context, _platform);
        } else if (snapshot.hasError) {
          return widget.errorBuilder(context, _platform);
        } else if (snapshot.hasData && snapshot.data!) {
          if (widget.config != null) {
            return Settings(
                controller: widget.config!.settingsController,
                scenarioController: widget.config!.scenarioController,
                child: widget.builder(context, _platform));
          } else {
            return MultiSettings(
                providers: _providers,
                child: widget.builder(context, _platform));
          }
        } else {
          throw Exception();
        }
      },
    );
  } */ */

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
