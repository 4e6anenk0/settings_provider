import 'package:example/src/config_with_hooks_example/app.dart';
import 'package:example/src/config_with_hooks_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'src/config_example/web_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var generalConfig = GeneralConfig();
  var webConfig = WebConfig();

  await generalConfig.init();

  // This configuration is designed for a specific platform.
  // It will be initialized only on that platform.
  await webConfig.init();

  runApp(
    ConfigBuilder(
      providers: [
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
