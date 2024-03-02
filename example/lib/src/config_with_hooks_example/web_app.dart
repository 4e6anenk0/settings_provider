import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'home_screen.dart';
import 'settings.dart';

class ConfigAppForWeb extends StatelessWidget {
  const ConfigAppForWeb({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var setting = Config.from<WebConfig>(context).get(WebConfig.title);

    ThemeData theme;

    if (context.listenSetting<GeneralConfig>().get(GeneralConfig.isDarkMode)) {
      theme = ThemeData.dark(useMaterial3: true);
    } else {
      theme = ThemeData(useMaterial3: true);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Web Demo',
      initialRoute: '/',
      theme: theme,
      home: MyHomePage(title: setting),
    );
  }
}
