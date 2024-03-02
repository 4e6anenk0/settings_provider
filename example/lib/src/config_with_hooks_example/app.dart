import 'package:flutter/material.dart';
import 'package:settings_provider/settings_hooks.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';
import 'settings.dart';

class ConfigApp extends StatelessWidget {
  const ConfigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EnumPropertyBuilder<ThemeMode, GeneralConfig>(
      builder: (context, property) {
        //ThemeData theme;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: '/',
          theme: context.theme<GeneralConfig>().lightTheme,
          darkTheme: context.theme<GeneralConfig>().darkTheme,
          themeMode: property,
          home: const MyHomePage(title: 'Setting Example'),
        );
      },
      property: GeneralConfig.themeMode,
    );
  }
}
