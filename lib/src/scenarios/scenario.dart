import 'package:flutter/material.dart';

import '../../settings_provider.dart';

/// A class for building settings associated with Enum values.
///
/// Scenario can be treated as a Property. It can also be accessed through
/// methods similar to those in a standard Property. The difference is its
/// ability to handy use Enum in a local storage for re-mapping with
/// the corresponding Enum after inited new session.
/// With the ScenarioBuilder, dynamic configurations that depend on Enum can be
/// easily created.
class Scenario<T extends Enum> extends Property<T> {
  Scenario(
      {required this.actions, required super.defaultValue, super.isLocalStored})
      : super(id: defaultValue.runtimeType.toString());

  final List<T> actions;

  @override
  Scenario<T> copyWith(
      {List<T>? actions,
      Function(BuildContext context, T action)? scenario,
      T? defaultValue,
      String? id,
      bool? isLocalStored}) {
    return Scenario(
      actions: actions ?? this.actions,
      defaultValue: defaultValue ?? this.defaultValue,
      isLocalStored: isLocalStored ?? this.isLocalStored,
    );
  }
}
