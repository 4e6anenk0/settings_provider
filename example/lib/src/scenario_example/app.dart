import 'package:example/src/scenario_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';

class ScenarioApp extends StatelessWidget {
  const ScenarioApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScenarioBuilder(
      builder: (context, action) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: '/',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: action,
          home: const MyHomePage(title: 'Setting Scenario Example'),
        );
      },
      scenario: themeMode,
    );
  }
}
