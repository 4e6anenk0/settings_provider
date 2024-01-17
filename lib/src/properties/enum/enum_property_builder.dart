import 'package:flutter/widgets.dart';
import 'package:settings_provider/src/helpers/extensions.dart';
import 'package:settings_provider/src/interfaces/settings_controller_interface.dart';

import '../../settings.dart';
import 'enum_property.dart';

/// A class that allows you to build a tree of widgets based
/// on the stored (or set) Enum value
class EnumPropertyBuilder<T extends Enum, P extends BaseSettingsModel>
    extends StatefulWidget {
  const EnumPropertyBuilder({
    required this.builder,
    required this.property,
    super.key,
  });

  final Widget Function(BuildContext context, T value) builder;

  final EnumProperty<T> property;

  @override
  State<EnumPropertyBuilder> createState() => _EnumPropertyBuilderState<T, P>();
}

class _EnumPropertyBuilderState<T extends Enum, P extends BaseSettingsModel>
    extends State<EnumPropertyBuilder<T, P>> {
  late T _value;
  late ISettingsController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var model = context.listenSetting<P>();
    _controller = model.controller;
    _value = _controller!.get(widget.property);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value);
}
