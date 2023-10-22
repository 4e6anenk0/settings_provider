import '../settings_property.dart';

abstract interface class ISettingsController {
  Future<void> update<T>(Property<T> property);

  T get<T>(Property<T> property);

  void setForSession<T>(Property<T> property);

  Future<void> setForLocal<T>(Property<T> property);

  /// A method for synchronizing the settings of the current session with local storage.
  Future<void> match();

  Map<String, Object> getAll();
}
