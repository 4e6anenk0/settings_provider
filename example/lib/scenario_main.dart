import 'package:example/src/scenario_example/app.dart';
import 'package:example/src/scenario_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  // Now we can create a consistent constructor asynchronously
  SettingsController controller =
      await SettingsController.consist(properties: settings);

  ScenarioController scenarioController =
      await ScenarioController.init(scenarios: [themeMode]);

  runApp(
    Settings(
      settingsController: controller,
      scenarioController: scenarioController,
      child: const ScenarioApp(),
    ),
  );
}
