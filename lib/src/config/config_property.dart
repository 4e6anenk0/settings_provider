import '../scenarios/scenario.dart';
import '../scenarios/scenario_controller.dart';
import '../settings.dart';
import '../settings_controller.dart';
import '../settings_property.dart';

enum ConfigPlatform {
  ios,
  android,
  macos,
  linux,
  windows,
  web,
  general,
}

abstract class ConfigModel extends BaseSettingsModel {
  /* ConfigModel({
    required List<Property> properties,
    required List<ConfigPlatform> platforms,
    required String id,
    List<Scenario>? scenarios,
  })  : _properties = properties,
        _scenarios = scenarios,
        _platforms = platforms,
        _id = id;
 */
  /*  final List<Property> _properties;
  final List<Scenario>? _scenarios;
  final List<ConfigPlatform> _platforms;
  final String _id; */

  List<Property> get properties;
  List<Scenario>? get scenarios;
  List<ConfigPlatform> get platforms;
  String get id;

  late final SettingsController _settingsController;
  late final ScenarioController? _scenarioController;
  ScenarioController? get scenarioController => _scenarioController;
  SettingsController get settingsController => _settingsController;

  Future<bool> init() async {
    try {
      _settingsController =
          await SettingsController.consist(properties: properties, prefix: id);
      if (scenarios != null) {
        _scenarioController = await ScenarioController.init(
            scenarios: scenarios, prefix: '$id.Scenario.');
      } else {
        _scenarioController = null;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  T get<T>(Property<T> property) {
    if (scenarioController != null && property is Scenario) {
      return scenarioController!.get(property);
    }
    return settingsController.get(property);
  }

  @override
  Future<void> update<T>(Property<T> property) async {
    if (scenarioController != null && property is Scenario) {
      scenarioController!.update(property);
      notifyListeners();
    } else {
      await settingsController.update(property);
      notifyListeners();
    }
  }

  @override
  Future<void> setForLocal<T>(Property property) async {
    if (scenarioController != null && property is Scenario) {
      await scenarioController!.setForLocal(property);
    } else {
      await settingsController.setForLocal(property);
    }
  }

  @override
  void setForSession<T>(Property property) {
    if (scenarioController != null && property is Scenario) {
      scenarioController!.setForSession(property);
      notifyListeners();
    } else {
      settingsController.setForSession(property);
      notifyListeners();
    }
  }

  @override
  Future<void> match() async {
    if (scenarioController != null) {
      await scenarioController!.match();
    } else {
      await settingsController.match();
    }
  }

  @override
  Map<String, Object> getAll() {
    return settingsController.getAll();
  }
}
