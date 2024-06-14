import 'package:example/src/simple_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';

class RemoteApp extends StatelessWidget {
  const RemoteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ThemeData theme;
      // uses setting to get data from SettingsData
      if (context
          .listenSetting<GeneralSettings>()
          .get(GeneralSettings.isDarkMode)) {
        theme = ThemeData.dark(useMaterial3: true);
      } else {
        theme = ThemeData(useMaterial3: true);
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/',
        theme: theme,
        home: const MyHomePage(title: 'Setting Example'),
      );
    });
  }
}
