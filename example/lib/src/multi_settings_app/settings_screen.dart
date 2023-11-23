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
    _name = Settings.from<PersonalScreenSettings>(context)
        .get(PersonalScreenSettings.name);
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
              if (Settings.from<PersonalScreenSettings>(context)
                      .get(PersonalScreenSettings.name) !=
                  _name) {
                await Settings.from<PersonalScreenSettings>(context).update(
                    PersonalScreenSettings.name.copyWith(defaultValue: _name));
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
    _scaler = context
        .setting<HomeScreenSettings>()
        .get(HomeScreenSettings.counterScaler);
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
              if (Settings.from<HomeScreenSettings>(context)
                      .get(HomeScreenSettings.counterScaler) !=
                  _scaler) {
                if (_scaler != 0) {
                  Settings.from<HomeScreenSettings>(context).update(
                      HomeScreenSettings.counterScaler
                          .copyWith(defaultValue: _scaler));
                } else {
                  Settings.from<HomeScreenSettings>(context)
                      .update(HomeScreenSettings.counterScaler);
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
                              value = Settings.from<HomeScreenSettings>(context)
                                  .get(HomeScreenSettings.counterScaler)
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
          value: Settings.listenFrom<HomeScreenSettings>(context)
              .get(HomeScreenSettings.isDarkMode),
          onChanged: (newValue) {
            //print(newValue);
            //print(Settings.of<HomeScreenSettings>(context).get(isDarkMode));
            if (newValue !=
                Settings.from<HomeScreenSettings>(context)
                    .get(HomeScreenSettings.isDarkMode)) {
              Settings.from<HomeScreenSettings>(context).update(
                  HomeScreenSettings.isDarkMode
                      .copyWith(defaultValue: newValue));
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
