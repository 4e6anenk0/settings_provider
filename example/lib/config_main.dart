import 'package:example/src/config_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'src/config_example/web_app.dart';

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();
/* 
  var config = ConfigController();

  config.registerAll([GeneralConfig(), WebConfig()]); */

  //var generalConfig = GeneralConfig();
  //var webConfig = WebConfig();

  //await generalConfig.init();
  //await webConfig.init();

  Configurator.register(GeneralConfig());
  Configurator.register(WebConfig());

  Configurator.init;

/*   await config.init(); */

  runApp(
    ConfigProvider(
      child: ConfigAppForWeb(),
      providers: Configurator.providers,
    ),
  );

  /* runApp(
    ConfigBuilder(
      builder: (context, platform) {
        if (platform == ConfigPlatform.web) {
          return const ConfigAppForWeb();
        } else {
          return const ConfigApp();
        }
      },
    ),
  ); */
}
