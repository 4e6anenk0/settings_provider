import 'package:settings_provider/settings_provider.dart';

class GeneralConfig extends ConfigModel {
  @override
  String get id => 'General';

  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.general];

  @override
  List<Property> get properties => [isDarkMode, counterScaler, name];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  @override
  List<ISettingsStorage>? get scenarioStorages => null;

  @override
  List<ISettingsStorage>? get settingsStorages => null;

  static Property<bool> isDarkMode = const Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static Property<int> counterScaler = const Property(
    defaultValue: 1,
    id: 'counterScaler',
    isLocalStored: false,
  );

  static Property<String> name = const Property(
    defaultValue: "John",
    id: 'name',
    isLocalStored: false,
  );
}

class WebConfig extends ConfigModel {
  @override
  String get id => 'WebConfig';

  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.web];

  @override
  List<ISettingsStorage>? get scenarioStorages => null;

  @override
  List<ISettingsStorage>? get settingsStorages => null;

  @override
  List<Property> get properties => [title];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static Property<String> title = const Property(
    defaultValue: "It's Web App!",
    id: 'title',
    isLocalStored: false,
  );
}
