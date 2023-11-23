import 'package:example/src/scenario_example/settings.dart';
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
            SizedBox(height: 20),
            DarkModeSetting(),
            SizedBox(height: 10),
            CounterScalerSettings(),
            SizedBox(height: 20),
            ThemeModeSetting()
          ],
        ),
      ),
    );
  }
}

class ThemeModeSetting extends StatefulWidget {
  const ThemeModeSetting({super.key});

  @override
  State<ThemeModeSetting> createState() => _ThemeModeSettingState();
}

class _ThemeModeSettingState extends State<ThemeModeSetting> {
  //ThemeMode? mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //mode = context.listenSetting(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.style),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          flex: 4,
          child: Text('Theme mode'),
        ),
        PopupMenuButton(
          initialValue: context
              .listenSetting<GeneralSettings>()
              .get(GeneralSettings.themeMode),
          onSelected: (ThemeMode mode) {
            context
                .setting<GeneralSettings>()
                .update(GeneralSettings.themeMode.copyWith(defaultValue: mode));
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Text(ThemeMode.dark.name),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: Text(ThemeMode.light.name),
            ),
            PopupMenuItem(
              value: ThemeMode.system,
              child: Text(ThemeMode.system.name),
            ),
          ],
          child:
              const Row(children: [Text('Test'), Icon(Icons.arrow_drop_down)]),
        )
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
  int? _scaler;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.text = context
        .setting<GeneralSettings>()
        .get(GeneralSettings.counterScaler)
        .toString();
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
