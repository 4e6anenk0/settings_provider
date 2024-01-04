import 'package:example/src/enum_property_example/app.dart';
import 'package:example/src/enum_property_example/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  var generalSettings = GeneralSettings();

  await generalSettings.init();

  runApp(
    Settings(
      model: generalSettings,
      child: const EnumPropertyApp(),
    ),
  );
}
