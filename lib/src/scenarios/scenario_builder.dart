import 'package:flutter/widgets.dart';

import '../../settings_provider.dart';

class ScenarioBuilder<T extends Enum> extends StatefulWidget {
  const ScenarioBuilder({
    required this.builder,
    required this.scenario,
    super.key,
  });

  final Widget Function(BuildContext context, T action) builder;

  final Scenario<T> scenario;

  @override
  State<ScenarioBuilder> createState() => _ScenarioBuilderState<T>();
}

class _ScenarioBuilderState<T extends Enum> extends State<ScenarioBuilder<T>> {
  late T _action;
  late ScenarioController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = Settings.of(context, listen: true).scenarioController;
    _action = _controller!.get(widget.scenario);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _action);
}
