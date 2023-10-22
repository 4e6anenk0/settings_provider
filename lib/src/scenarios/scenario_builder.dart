import 'package:flutter/widgets.dart';

import '../../settings_provider.dart';

class ScenarioBuilder<T extends Enum> extends StatefulWidget {
  const ScenarioBuilder(
      {required this.builder, required this.scenario, super.key});

  final Widget Function(BuildContext context, T action) builder;

  final Scenario<T> scenario;

  @override
  State<ScenarioBuilder> createState() => _ScenarioBuilderState<T>();
}

class _ScenarioBuilderState<T extends Enum> extends State<ScenarioBuilder<T>> {
  late T action;
  late ScenarioController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = Settings.of(context, listen: true).scenarioController;
    action = _controller!.get(widget.scenario);
  }

  Widget _builder(context, action) {
    if (widget.scenario.scenario != null) {
      widget.scenario.scenario!(context, action);
    }
    return widget.builder(context, action);
  }

  @override
  Widget build(BuildContext context) => _builder(context, action);
}
