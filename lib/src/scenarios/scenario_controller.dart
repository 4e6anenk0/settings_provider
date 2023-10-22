import '../../settings_provider.dart';
import '../helpers/settings_controller_interface.dart';

/// A class for managing `Enum` settings through `Scenario` properties.
///
/// Implements an extension over the base `SettingsController` class for `Property`.
class ScenarioController implements ISettingsController {
  ScenarioController._(this.scenarios, this._prefix);

  static Future<ScenarioController> init(
      {List<Scenario>? scenarios, String? prefix}) async {
    ScenarioController controller = ScenarioController._(scenarios, prefix);
    await controller._init();
    return controller;
  }

  late final List<Scenario>? scenarios;
  final String? _prefix;
  final Map<Enum, String> _mapEnumToString = {};
  final Map<String, Enum> _mapStringToEnum = {};
  final List<Property> _convertedScenarios = [];
  late final SettingsController _settingsController;

  Future<void> _init() async {
    if (scenarios != null) {
      _prepareConvertedScenarios(scenarios!);
      _settingsController = await SettingsController.consist(
          properties: _convertedScenarios, prefix: _prefix ?? '.Scenarios');
    }
  }

  /// A method that processes a list of scenarios and creates a mapping and a
  /// list of properties that can be stored in storage.
  ///
  /// While Scenario is a class based on Property, it's not possible
  /// to store Enum values without conversion.
  void _prepareConvertedScenarios(List<Scenario> scenarios) {
    for (Scenario scenario in scenarios) {
      _parseScenarioEnums(scenario);
      _convertedScenarios.add(_convertScenarioToProperty(scenario));
    }
  }

  /// A method for parsing Enum values and creating mapping for
  /// the current program. Every time, when settings in the code is changed,
  /// a new mapping Enum -> String, String -> Enum will be create.
  _parseScenarioEnums(Scenario scenario) {
    for (Enum action in scenario.actions) {
      _mapEnumToString[action] = action.name;
      _mapStringToEnum[action.name] = action;
    }
  }

  /// A method for converting Scenario into a format suitable for storage as Property.
  Property<String> _convertScenarioToProperty(Scenario scenario) {
    return Property(
        defaultValue: _mapEnumToString[scenario.defaultValue]!,
        id: scenario.id);
  }

  @override
  T get<T>(Property<T> scenario) {
    Property property = _convertScenarioToProperty(scenario as Scenario);
    var result = _settingsController.get(property);
    return _mapStringToEnum[result] as T;
  }

  @override
  Map<String, Object> getAll() {
    return _settingsController.getAll();
  }

  @override
  Future<void> match() async {
    _settingsController.match();
  }

  @override
  Future<void> setForLocal<T>(Property<T> scenario) async {
    Property property = _convertScenarioToProperty(scenario as Scenario);
    await _settingsController.setForLocal(property);
  }

  @override
  void setForSession<T>(Property scenario) {
    Property property = _convertScenarioToProperty(scenario as Scenario);
    _settingsController.setForSession(property);
  }

  @override
  Future<void> update<T>(Property<T> scenario) async {
    Property property = _convertScenarioToProperty(scenario as Scenario);
    await _settingsController.update(property);
  }
}
