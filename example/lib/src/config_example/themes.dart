import 'package:flutter/material.dart';

ThemeData pinkLightTheme =
    ThemeData(colorScheme: const ColorScheme.light(primary: Colors.pink));
ThemeData pinkDarkTheme =
    ThemeData(colorScheme: const ColorScheme.dark(primary: Colors.pink));

ThemeData greenLightTheme =
    ThemeData(colorScheme: const ColorScheme.light(primary: Colors.green));
ThemeData greenDarkTheme =
    ThemeData(colorScheme: const ColorScheme.dark(primary: Colors.green));

abstract interface class ITheme {
  ThemeData get light;
  ThemeData get dark;
}

class CustomTheme implements ITheme {
  CustomTheme({required ThemeData light, required ThemeData dark, String? id})
      : _dark = dark,
        _light = light,
        _id = id;

  final ThemeData _light;
  final ThemeData _dark;
  final String? _id;

  @override
  String toString() {
    return _id ?? '';
  }

  @override
  ThemeData get dark => _dark;

  @override
  ThemeData get light => _light;
}

class PinkTheme implements ITheme {
  @override
  ThemeData get dark => pinkDarkTheme;

  @override
  ThemeData get light => pinkLightTheme;

  @override
  String toString() {
    return 'Pink Theme';
  }
}

class GreenTheme implements ITheme {
  @override
  ThemeData get dark => greenDarkTheme;

  @override
  ThemeData get light => greenLightTheme;

  @override
  String toString() {
    return 'Green Theme';
  }
}
