import 'package:settings_provider/settings_provider.dart';

// A separate model for home screen settings
class HomeScreenSettings extends SettingsModel {
  @override
  List<Property> get properties => [isDarkMode, counterScaler];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static const Property<int> counterScaler =
      Property(defaultValue: 1, id: 'counterScaler');
}

// A separate model for personal screen settings
class PersonalScreenSettings extends SettingsModel {
  @override
  List<Property> get properties => [name];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static const Property<String> name =
      Property(defaultValue: 'John', id: 'name');
}
