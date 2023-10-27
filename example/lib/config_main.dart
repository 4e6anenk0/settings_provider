import 'package:example/src/simple_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'src/simple_app/app.dart';

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  Config.init();

  runApp(
    ConfigBuilder(
      builder: (context, platform) {
        if (platform == Platform.web) {
        } else {}
      },
    ),
  );
}
