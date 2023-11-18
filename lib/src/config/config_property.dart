import '../scenarios/scenario.dart';
import '../scenarios/scenario_controller.dart';
import '../settings.dart';
import '../settings_controller.dart';
import '../settings_property.dart';
import 'config_provider.dart';

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
  List<Property> get properties;
  List<Scenario>? get scenarios;
  List<ConfigPlatform> get platforms;
  String get id;

  late final SettingsController _settingsController;
  late final ScenarioController? _scenarioController;

  @override
  ScenarioController? get scenarioController => _scenarioController;

  @override
  SettingsController get settingsController => _settingsController;

  bool _isInited = false;
  bool get isInited => _isInited;

  bool _isCorrectPlatform() {
    if (platforms.contains(ConfigPlatform.general) ||
        platforms.contains(Config.platform)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> init() async {
    if (_isCorrectPlatform()) {
      try {
        _settingsController = await SettingsController.consist(
            properties: properties, prefix: id);
        if (scenarios != null) {
          _scenarioController = await ScenarioController.init(
              scenarios: scenarios, prefix: '$id.Scenario.');
        } else {
          _scenarioController = null;
        }
        _isInited = true;
        return true;
      } catch (e) {
        return false;
      }
    } else {
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
