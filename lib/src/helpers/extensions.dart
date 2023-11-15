import 'package:flutter/material.dart';
import 'package:settings_provider/settings_provider.dart';

import '../settings.dart';
import '../settings_property.dart';

extension SettingsContextHelper on BuildContext {
  T config<T extends ConfigModel>() {
    return Config.of<T>(this);
  }

  T listenConfig<T extends ConfigModel>() {
    return Config.of<T>(this, listen: true);
  }

  T setting<T extends SettingsModel>({bool? listen}) {
    return Settings.of(this, listen: listen ?? false);
  }

  /// allows you to get settings without subscribing to the changes.
  ///
  /// Thanks to this, the data can be used in the initState() method and
  /// in various callback-functions of the type onChange().
  T getSetting<S extends ConfigModel, T>(Property<T> property) {
    return Config.of<S>(this).get(property);
  }

  /// allows you to get settings subscribed to changes.
  ///
  /// It is important to consider that this method must be used in the context
  /// of the widget tree or in the didChangeDependencies() method
  /// to get and subscribe to data.
  T listenSetting<S extends ConfigModel, T>(Property<T> property) {
    return Config.of<S>(this, listen: true).get(property);
  }

  /// A method for updating data values of both the current session
  /// and data stored in local storage.
  ///
  /// This method executes asynchronously in the background.
  Future<void> updateSetting<S extends ConfigModel, T>(
      Property<T> property) async {
    await Config.of<S>(this).update(property);
  }

  /// A method that allows you to set a value in the data of the application (current session).
  ///
  /// It takes less cost, time and is not an asynchronous operation.
  /// This can be useful for frequent changes of the current state
  /// of the application and delayed saving to local storage of those parameters
  /// that are stored locally.
  void setSessionSetting<S extends ConfigModel, T>(Property<T> property) {
    Config.of<S>(this).setForSession(property);
  }

  /// Method to set the setting value immediately to local storage.
  ///
  /// This takes time and will not be synchronized until the application is restarted.
  Future<void> setLocalSetting<S extends ConfigModel, T>(
      Property<T> property) async {
    await Config.of<S>(this).setForLocal(property);
  }

  /// A method that reconciles all the settings of the current session to the local storage.
  ///
  /// May take longer to execute than other functions because it needs to iterate over
  /// and save all new properties. It is useful to do after changes setSessionSetting(),
  /// when not all settings have been processed that require local saving.
  Future<void> matchAllSettings<S extends ConfigModel>() async {
    await Config.of<S>(this).match();
  }

  /// A method that allows you to get a Map object of all the settings of the current session.
  Map<String, Object> getAllSettings<S extends ConfigModel>() {
    return Config.of<S>(this).getAll();
  }
}
