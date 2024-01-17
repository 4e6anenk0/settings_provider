import 'package:example/src/enum_property_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';

class EnumPropertyApp extends StatelessWidget {
  const EnumPropertyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return EnumPropertyBuilder<ThemeMode, GeneralSettings>(
      builder: (context, value) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: '/',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: value,
          home: const MyHomePage(title: 'Setting EnumProperty Example'),
        );
      },
      property: GeneralSettings.themeMode,
    );
  }
}
