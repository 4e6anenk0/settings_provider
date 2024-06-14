import 'package:example/src/config_example/app.dart';
import 'package:example/src/config_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'src/config_example/web_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var generalConfig = GeneralConfig();
  var webConfig = WebConfig();

  await generalConfig.init();
  await webConfig.init();

/*   runApp(
    Config(
      providers: [
        SettingsProvider(
          model: generalConfig,
        ),
        SettingsProvider(
          model: webConfig,
        )
      ],
      child: ConfigAppForWeb(),
    ),
  ); */

  runApp(
    ConfigBuilder(
      configs: [
        SettingsProvider(
          model: generalConfig,
        ),
        SettingsProvider(
          model: webConfig,
        )
      ],
      builder: (context, platform) {
        if (platform == ConfigPlatform.web) {
          return const ConfigAppForWeb();
        } else {
          return const ConfigApp();
        }
      },
    ),
  );
}
