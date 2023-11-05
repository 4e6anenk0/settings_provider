import 'package:example/src/multi_settings_app/app.dart';
import 'package:example/src/multi_settings_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

// A separate model for home screen settings
class HomeScreenSettings extends SettingsModel {
  HomeScreenSettings({required super.settingsController});
}

// A separate model for personal screen settings
class PersonalScreenSettings extends SettingsModel {
  PersonalScreenSettings({required super.settingsController});
}

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  // Now we can create a consistent constructor asynchronously
  SettingsController homeScreenController = await SettingsController.consist(
      properties: settings, prefix: 'HomeScreen.');
  SettingsController personalScreenController =
      await SettingsController.consist(
          properties: personalSettings, prefix: 'PersonalScreen.');

  runApp(
    // Instead of Settings, we use MultiSettings
    MultiSettings(
      // And we implement our models using SettingsProvider
      providers: [
        SettingsProvider(
            model: HomeScreenSettings(
          settingsController: homeScreenController,
        )),
        SettingsProvider(
            model: PersonalScreenSettings(
          settingsController: personalScreenController,
        )),
      ],
      child: const MultiSettingsApp(),
    ),
  );
}
