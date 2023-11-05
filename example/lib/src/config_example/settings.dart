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
    defaultValue: "Jonh",
    id: 'name',
    isLocalStored: false,
  );
}
