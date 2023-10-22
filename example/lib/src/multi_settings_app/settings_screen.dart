import 'package:example/multi_main.dart';
import 'package:example/src/multi_settings_app/settings.dart';
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
            NameSettings(),
          ],
        ),
      ),
    );
  }
}

class NameSettings extends StatefulWidget {
  const NameSettings({super.key});

  @override
  State<NameSettings> createState() => _NameSettingsState();
}

class _NameSettingsState extends State<NameSettings> {
  late TextEditingController _textController;
  late String _name;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _name = Settings.of<PersonalScreenSettings>(context).get(name);
    _textController.text = _name;
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
        const Icon(Icons.person),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 3,
          child: Text('You personal name'),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: _textController,
            onTapOutside: (event) async {
              if (Settings.of<PersonalScreenSettings>(context).get(name) !=
                  _name) {
                await Settings.of<PersonalScreenSettings>(context)
                    .update(name.copyWith(defaultValue: _name));
              }
            },
            onChanged: (value) async {
              _name = value;
            },
          ),
        ),
      ],
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
  late int? _scaler;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scaler = Settings.of<HomeScreenSettings>(context).get(counterScaler);
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
              if (Settings.of<HomeScreenSettings>(context).get(counterScaler) !=
                  _scaler) {
                if (_scaler != 0) {
                  Settings.of<HomeScreenSettings>(context)
                      .update(counterScaler.copyWith(defaultValue: _scaler));
                } else {
                  Settings.of<HomeScreenSettings>(context)
                      .update(counterScaler);
                }
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
                              value = Settings.of<HomeScreenSettings>(context)
                                  .get(counterScaler)
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
            },
          ),
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
          value: Settings.of<HomeScreenSettings>(context, listen: true)
              .get(isDarkMode),
          onChanged: (newValue) {
            //print(newValue);
            //print(Settings.of<HomeScreenSettings>(context).get(isDarkMode));
            if (newValue !=
                Settings.of<HomeScreenSettings>(context).get(isDarkMode)) {
              Settings.of<HomeScreenSettings>(context)
                  .update(isDarkMode.copyWith(defaultValue: newValue));
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
