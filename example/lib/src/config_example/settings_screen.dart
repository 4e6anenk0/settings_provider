import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'settings.dart';

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
    _scaler =
        Config.of<GeneralConfig>(context).get(GeneralConfig.counterScaler);
    _textController.text = _scaler.toString();
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
                  print("new scaler: $_scaler");
                  Config.of<GeneralConfig>(context).update(GeneralConfig
                      .counterScaler
                      .copyWith(defaultValue: _scaler));
                } else {
                  print("!!!!");
                  Config.of<GeneralConfig>(context)
                      .update(GeneralConfig.counterScaler);
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
                                value = Config.of<GeneralConfig>(context)
                                    .get(GeneralConfig.counterScaler)
                                    .toString();
                                Navigator.pop(context);
                              },
                              child: const Text('OK!'))
                        ],
                      );
                    },
                  );
                } else if (value == '') {
                  _scaler = 1;
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
          value: Config.of<GeneralConfig>(context, listen: true)
              .get(GeneralConfig.isDarkMode),
          onChanged: (newValue) {
            if (newValue !=
                Config.of<GeneralConfig>(context)
                    .get(GeneralConfig.isDarkMode)) {
              // if newValue is different we can update our settings
              Config.of<GeneralConfig>(context).update(
                  GeneralConfig.isDarkMode.copyWith(defaultValue: newValue));
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
