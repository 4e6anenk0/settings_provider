import 'package:settings_provider/src/config/base_config.dart';

import '../scenarios/scenario.dart';
import '../settings_property.dart';

class Config {
  static List<BaseConfig> _configs = [];

  static void addConfig(BaseConfig config) {
    _configs.add(config);
  }

  static void add(
      {required List<Property> properties,
      List<Scenario>? scenarios,
      required Platform platform,
      required String id}) {
    _configs
        .add(BaseConfig(properties: properties, scenarios: scenarios, id: id));
  }
}
