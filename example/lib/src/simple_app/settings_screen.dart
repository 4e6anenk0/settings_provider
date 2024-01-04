import 'package:example/src/simple_app/settings.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: const [
            SettingsTitle(),
            SizedBox(
              height: 20,
            ),
            DarkModeSetting(),
            CounterScalerSettings(),
          ],
        ),
      ),
    );
  }
}

class CounterScalerSettings extends StatefulWidget {
  const CounterScalerSettings({super.key});

  @override
  State<CounterScalerSettings> createState() => _CounterScalerSettingsState();
}

class _CounterScalerSettingsState extends State<CounterScalerSettings> {
  late TextEditingController _textController;
  int? _scaler;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    var scaler =
        context.setting<GeneralSettings>().get(GeneralSettings.counterScaler);
    _textController.text = scaler.toString();
    _scaler = scaler;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.scale),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 3,
          child: Text('Scale factor to counter'),
        ),
        Expanded(
          flex: 1,
          child: TextField(
              controller: _textController,
              onTapOutside: (event) {
                if (_scaler != 0) {
                  context.setting<GeneralSettings>().update(GeneralSettings
                      .counterScaler
                      .copyWith(defaultValue: _scaler));
                } else {
                  context
                      .setting<GeneralSettings>()
                      .update(GeneralSettings.counterScaler);
                }
              },
              onChanged: (value) async {
                _scaler = int.tryParse(value);
                if (_scaler == null && value != '') {
                  await showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Data parsing Error!'),
                        content: Text(
                            'The $value can`t parse, cos it`s not a number!'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                value = context
                                    .setting<GeneralSettings>()
                                    .get(GeneralSettings.counterScaler)
                                    .toString();
                                Navigator.pop(context);
                              },
                              child: const Text('OK!'))
                        ],
                      );
                    },
                  );
                } else if (value == '') {
                  _scaler = 0;
                }
              }),
        ),
      ],
    );
  }
}

class DarkModeSetting extends StatelessWidget {
  const DarkModeSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.color_lens),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 4,
          child: Text('Dark Mode'),
        ),
        Switch(
          // switch use the getSetting() method to get the value
          value: context
              .listenSetting<GeneralSettings>()
              .get(GeneralSettings.isDarkMode),
          onChanged: (newValue) {
            if (newValue !=
                context
                    .setting<GeneralSettings>()
                    .get(GeneralSettings.isDarkMode)) {
              // if newValue is different we can update our settings
              context.setting<GeneralSettings>().update(
                  GeneralSettings.isDarkMode.copyWith(defaultValue: newValue));
            }
          },
        ),
      ],
    );
  }
}

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        const Text(
          'Settings',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
