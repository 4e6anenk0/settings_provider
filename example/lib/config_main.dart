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

  var generalConfig = GeneralConfig();
  var webConfig = WebConfig();

  await generalConfig.init();
  await webConfig.init();

  //await Config.init();

/*   await config.init(); */

  runApp(
    Config(
      providers: [
        ConfigProvider(
          config: generalConfig,
        ),
        ConfigProvider(
          config: webConfig,
        )
      ],
      child: ConfigAppForWeb(),
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
