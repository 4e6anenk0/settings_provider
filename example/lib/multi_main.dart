import 'package:example/src/multi_settings_app/app.dart';
import 'package:example/src/multi_settings_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  var homeSettings = HomeScreenSettings();
  var personalSettings = PersonalScreenSettings();

  await homeSettings.init();
  await personalSettings.init();

  runApp(
    // Instead of Settings, we use MultiSettings
    MultiSettings(
      // And we implement our models using SettingsProvider
      providers: [
        SettingsProvider(model: homeSettings),
        SettingsProvider(model: personalSettings),
      ],
      child: const MultiSettingsApp(),
    ),
  );
}
