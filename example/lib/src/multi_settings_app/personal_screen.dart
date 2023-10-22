import 'package:example/multi_main.dart';
import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import 'settings.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = Settings.of<PersonalScreenSettings>(context).get(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(child: Text('Its personal screen. You name is $_name')),
    );
  }
}
