import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

class ThemeProperty<T extends ThemeData> extends BaseProperty<T> {
  const ThemeProperty({
    required super.defaultValue,
    required super.id,
    bool? isLocalStored,
  }) : super(isLocalStored: isLocalStored ?? false);

  ThemeProperty<T> copyWith({
    T? defaultValue,
    bool? isLocalStored,
  }) {
    return ThemeProperty(
      defaultValue: defaultValue ?? this.defaultValue,
      id: id,
      isLocalStored: isLocalStored ?? this.isLocalStored,
    );
  }

  @override
  String get type => 'ThemeProperty';
}
