import 'package:flutter/material.dart';

import '../base/property.dart';

class ThemeDesc {
  const ThemeDesc({
    required this.lightTheme,
    required this.darkTheme,
    required this.themeID,
  });

  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final String themeID;
}

class ThemeProperty<T extends ThemeDesc> extends BaseProperty<T> {
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
