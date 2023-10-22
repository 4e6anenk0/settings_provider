import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

var themeMode =
    Scenario(actions: ThemeMode.values, defaultValue: ThemeMode.dark);

const isDarkMode = Property<bool>(
  defaultValue: false,
  id: 'isDarkMode',
  isLocalStored: true,
);

const counterScaler = Property<int>(defaultValue: 1, id: 'counterScaler');

List<Property> settings = [isDarkMode, counterScaler];
