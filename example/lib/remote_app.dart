import 'package:example/src/remote_settings_app/app.dart';
import 'package:example/src/remote_settings_app/remote_settings_storage.dart';
import 'package:example/src/simple_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:settings_provider/settings_provider.dart';

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  var generalSettings = GeneralSettings();

  generalSettings.storage.addStorage(RemoteSettingsStorage());
  generalSettings.storage.addDependency(Property, [RemoteSettingsStorage]);

  await generalSettings.init();

  runApp(
    Settings(
      model: generalSettings,
      child: const RemoteApp(),
    ),
  );
}
