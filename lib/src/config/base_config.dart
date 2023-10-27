import '../../settings_provider.dart';
import 'config.dart';

enum Platform { ios, android, macos, linux, windows, web, general }

abstract class BaseConfig {
  List<Property> properties() => [];
  List<Scenario>? scenarios() => null;
  Platform platform() => Platform.general;
}

class GeneralConfig implements BaseConfig {
  
  @override
  Platform platform() => Platform.general;

  @override
  List<Property> properties() {
    return [
      const Property(defaultValue: 1, id: 'counter'),
    ];
  }

  @override
  List<Scenario<Enum>>? scenarios() => null;

}

class GeneralConfig2 extends BaseConfig {
  @override
  List<Property> properties() => [
    Property(defaultValue: defaultValue, id: id),
  ];
}

void main() {
  Config.addConfig(GeneralConfig());
      id: "AndroidSettings");
  SettingsController controller = Config.getSettingsController();
}
