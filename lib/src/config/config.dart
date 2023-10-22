import 'package:flutter/material.dart';

import '../settings_property.dart';

class Config<T extends Enum> extends Property<T> {
  Config({required this.actions, this.scenario, required super.defaultValue})
      : super(id: T.runtimeType.toString());

  final List<T> actions;
  final List<Property> properties;
  final Function(BuildContext context, T action)? scenario;
}
