import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';
import 'settings.dart';

class ConfigApp extends StatelessWidget {
  const ConfigApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ThemeData theme;
      // uses setting to get data from SettingsData
      if (Config.of<GeneralConfig>(context, listen: true)
          .get(GeneralConfig.isDarkMode)) {
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
