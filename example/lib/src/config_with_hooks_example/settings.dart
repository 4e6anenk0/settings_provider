import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

ColorScheme greenLightThemeScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Color.fromARGB(255, 242, 255, 237),
    secondary: Color.fromARGB(255, 188, 225, 41),
    onSecondary: Color.fromARGB(255, 42, 42, 42),
    error: Colors.red,
    onError: Color.fromARGB(255, 43, 43, 43),
    background: Color.fromARGB(255, 240, 244, 229),
    onBackground: Color.fromARGB(255, 29, 29, 29),
    surface: Color.fromARGB(255, 212, 232, 194),
    onSurface: Color.fromARGB(255, 92, 94, 85));

ColorScheme greenDarkThemeScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color.fromARGB(255, 99, 126, 69),
    onPrimary: Color.fromARGB(255, 235, 244, 209),
    secondary: Color.fromARGB(255, 40, 44, 37),
    onSecondary: Color.fromARGB(255, 155, 191, 121),
    error: Colors.red,
    onError: Color.fromARGB(255, 43, 40, 40),
    background: Color.fromARGB(255, 42, 44, 40),
    onBackground: Color.fromARGB(255, 136, 187, 85),
    surface: Color.fromARGB(255, 86, 91, 79),
    onSurface: Color.fromARGB(255, 203, 219, 191));

ColorScheme orangeLightThemeScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 217, 122, 20),
  onPrimary: Color.fromARGB(255, 220, 220, 220),
  secondary: Color.fromARGB(255, 94, 79, 27),
  onSecondary: Color.fromARGB(255, 240, 239, 231),
  error: Colors.red,
  onError: Color.fromARGB(255, 37, 37, 37),
  background: Colors.white,
  onBackground: Color.fromARGB(255, 41, 41, 41),
  surface: Color.fromARGB(255, 37, 37, 37),
  onSurface: Color.fromARGB(255, 226, 226, 226),
);

ColorScheme orangeDarkThemeScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 217, 122, 20),
  onPrimary: Color.fromARGB(255, 40, 40, 40),
  secondary: Color.fromARGB(255, 195, 153, 1),
  onSecondary: Color.fromARGB(255, 87, 84, 0),
  error: Colors.red,
  onError: Color.fromARGB(255, 41, 41, 41),
  background: Color.fromARGB(255, 36, 31, 21),
  onBackground: Color.fromARGB(255, 205, 205, 205),
  surface: Color.fromARGB(255, 146, 99, 39),
  onSurface: Color.fromARGB(255, 211, 202, 186),
);

class GeneralConfig extends ConfigModel {
  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.general];

  @override
  List<ThemeDesc>? get themes => [
        orangeTheme,
        greenTheme,
      ];

  static ThemeDesc orangeTheme = ThemeDesc(
      lightTheme: ThemeData.from(colorScheme: orangeLightThemeScheme),
      darkTheme: ThemeData.from(colorScheme: orangeDarkThemeScheme),
      themeID: 'orangeTheme');

  static ThemeDesc greenTheme = ThemeDesc(
      lightTheme: ThemeData.from(colorScheme: greenLightThemeScheme),
      darkTheme: ThemeData.from(colorScheme: greenDarkThemeScheme),
      themeID: 'greenTheme');

  @override
  List<BaseProperty> get properties => [
        isDarkMode,
        counterScaler,
        name,
        themeMode,
        theme,
      ];

  static Property<bool> isDarkMode = const Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: false,
  );

  static Property<int> counterScaler = const Property(
    defaultValue: 1,
    id: 'counterScaler',
    isLocalStored: false,
  );

  static Property<String> name = const Property(
    defaultValue: "John",
    id: 'name',
    isLocalStored: false,
  );

  static EnumProperty<ThemeMode> themeMode = const EnumProperty(
      id: 'themeMode',
      values: ThemeMode.values,
      defaultValue: ThemeMode.dark,
      isLocalStored: true);
}

class WebConfig extends ConfigModel {
  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.web];

  @override
  List<Property> get properties => [title];

  static Property<String> title = const Property(
    defaultValue: "It's Web App!",
    id: 'title',
    isLocalStored: false,
  );
}
