import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:settings_provider/settings_provider.dart';
import 'package:settings_provider/src/config/base_config.dart';

import '../settings.dart';
import 'config.dart';

class ConfigBuilder extends StatefulWidget {
  const ConfigBuilder({super.key, required this.builder});

  //final Widget child;

  final Widget Function(BuildContext context, Platform platform) builder;

  /// A controller is required to manage settings
  final Config config = Config.getInstance();

  final Scenario configScenario =
      Scenario(actions: Platform.values, defaultValue: Platform.general);

  @override
  State<ConfigBuilder> createState() => _ConfigProviderState();
}

class _ConfigProviderState extends State<ConfigBuilder> {
  //late final model = ConfigModel(widget.controller);

  @override
  void dispose() {
    super.dispose();
  }

  Widget _build() {
    return Settings(
      controller: controller,
      scenarioController: controller,
      child: ScenarioBuilder(
        builder: (context, action) {
          return widget.builder(context, action);
        },
        scenario: widget.configScenario,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build();
  }
}
