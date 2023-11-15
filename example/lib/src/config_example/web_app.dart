import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';
import 'settings.dart';

class ConfigAppForWeb extends StatelessWidget {
  const ConfigAppForWeb({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("TEST");
    //String setting = Config.of<WebConfig>(context).get(WebConfig.title);
    print("This is SETTING:" + 'setting');

    print("TEST2");
    ThemeData theme;
    print("TEST3");
    //var r = Config.of<GeneralConfig>(context).get(GeneralConfig.isDarkMode);
    var r = context.config<GeneralConfig>().get(GeneralConfig.isDarkMode);
    print("$r");
    // uses setting to get data from SettingsData
    if (context.listenConfig<GeneralConfig>().get(GeneralConfig.isDarkMode)) {
      theme = ThemeData.dark(useMaterial3: true);
    } else {
      theme = ThemeData(useMaterial3: true);
    }
    print("TEST4");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web Demo',
      initialRoute: '/',
      theme: theme,
      home: MyHomePage(title: 'setting'),
    );
  }
}
