import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

/// Клас для побудови налаштувань які зіставлені з Enum.
///
/// Scenario можна розглядати як звичайне Property. До нього також можна отримати
/// доступ через методи які є і y звичайного Property. Відмінність
/// Scenario полягає в тому, що даний клас дозволяє зручно використовувати Enum
/// для збереження у локальному сховищі для повторного зіставлення з відповідним
/// Enum після відновлення сесії. А завдяки ScenarioBuilder можна лекго
/// створювати динамічні конфігурації, які залежаті від Enum
class Scenario<T extends Enum> extends Property<T> {
  Scenario(
      {required this.actions,
      this.scenario,
      required super.defaultValue,
      super.isLocalStored})
      : super(id: defaultValue.runtimeType.toString());

  final List<T> actions;
  final Function(BuildContext context, T action)? scenario;

  @override
  Scenario<T> copyWith(
      {List<T>? actions,
      Function(BuildContext context, T action)? scenario,
      T? defaultValue,
      String? id,
      bool? isLocalStored}) {
    return Scenario(
      actions: actions ?? this.actions,
      scenario: scenario ?? this.scenario,
      defaultValue: defaultValue ?? this.defaultValue,
      isLocalStored: isLocalStored ?? this.isLocalStored,
    );
  }
}
