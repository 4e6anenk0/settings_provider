import 'package:flutter/material.dart';

import '../settings.dart';
import '../settings_property.dart';

extension SettingsContextHelper on BuildContext {
  /// allows you to get settings without subscribing to the changes.
  ///
  /// Thanks to this, the data can be used in the initState() method and
  /// in various callback-functions of the type onChange().
  T getSetting<T>(Property<T> property) {
    return Settings.of(this).get(property);
  }

  /// allows you to get settings subscribed to changes.
  ///
  /// It is important to consider that this method must be used in the context
  /// of the widget tree or in the didChangeDependencies() method
  /// to get and subscribe to data.
  T listenSetting<T>(Property<T> property) {
    return Settings.of(this, listen: true).get(property);
  }

  /// A function for updating data values of both the current session
  /// and data stored in local storage.
  ///
  /// This method executes asynchronously in the background.
  Future<void> updateSetting(Property property) async {
    await Settings.of(this).update(property);
  }

  /// A function that allows you to set a value in the data of the application (current session).
  ///
  /// It takes less cost, time and is not an asynchronous operation.
  /// This can be useful for frequent changes of the current state
  /// of the application and delayed saving to local storage of those parameters
  /// that are stored locally.
  void setSessionSetting(Property property) {
    Settings.of(this).setForSession(property);
  }

  /// Function to set the setting value immediately to local storage.
  ///
  /// This takes time and will not be synchronized until the application is restarted.
  Future<void> setLocalSetting(Property property) async {
    await Settings.of(this).setForLocal(property);
  }

  /// A function that reconciles all the settings of the current session to the local storage.
  ///
  /// May take longer to execute than other functions because it needs to iterate over
  /// and save all new properties. It is useful to do after changes setSessionSetting(),
  /// when not all settings have been processed that require local saving.
  Future<void> matchAllSettings() async {
    await Settings.of(this).match();
  }

  /// A function that allows you to get a Map object of all the settings of the current session.
  Map<String, Object> getAllSettings() {
    return Settings.of(this).getAll();
  }
}
