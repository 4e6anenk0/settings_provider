import 'package:flutter/widgets.dart';

import '../../settings_provider.dart';

class ScenarioBuilder<T extends Enum, P extends BaseSettingsModel>
    extends StatefulWidget {
  const ScenarioBuilder({
    required this.builder,
    required this.scenario,
    super.key,
  });

  final Widget Function(BuildContext context, T action) builder;

  final Scenario<T> scenario;

  @override
  State<ScenarioBuilder> createState() => _ScenarioBuilderState<T, P>();
}

class _ScenarioBuilderState<T extends Enum, P extends BaseSettingsModel>
    extends State<ScenarioBuilder<T, P>> {
  late T _action;
  late ScenarioController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = context.listenSetting<P>().scenarioController;
    _action = _controller!.get(widget.scenario);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _action);
}
