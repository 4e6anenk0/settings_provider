import 'package:example/src/multi_settings_app/home_screen.dart';
import 'package:example/src/multi_settings_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import '../../main.dart';

class MultiSettingsApp extends StatelessWidget {
  const MultiSettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ThemeData theme;
      // uses setting to get data from SettingsData
      if (Settings.of<HomeScreenSettings>(context, listen: true)
          .get(isDarkMode)) {
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
