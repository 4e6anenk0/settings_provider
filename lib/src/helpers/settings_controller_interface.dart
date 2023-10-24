import '../settings_property.dart';

abstract interface class ISettingsController {
  /// A method that helps to update data from the property.
  Future<void> update<T>(Property<T> property);

  /// A method that helps to get data from a property.
  T get<T>(Property<T> property);

  void setForSession<T>(Property<T> property);

  Future<void> setForLocal<T>(Property<T> property);

  /// A method for synchronizing the settings of the current session with local storage.
  Future<void> match();

  /// A method for obtaining the Map object of all settings of the current session.
  Map<String, Object> getAll();
}
