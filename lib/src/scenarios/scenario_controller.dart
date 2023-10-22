import '../../settings_provider.dart';
import '../helpers/settings_controller_interface.dart';

/// Клас для керування налаштуваннями Enum через Scenario властивості
///
/// Реалізує надбудову над базовим класом SettingsController для Property
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

  /// Метод яка оброблює список сценаріїв та формує з них Map зіставлення та
  /// список властивостей, які можна зберігати у сховищі.
  ///
  /// Хоча Scenario і є класом який успадкований від Property, але неможливо
  /// зберігати значення Enum без попередньої конвертації.
  void _prepareConvertedScenarios(List<Scenario> scenarios) {
    for (Scenario scenario in scenarios) {
      _parseScenarioEnums(scenario);
      _convertedScenarios.add(_convertScenarioToProperty(scenario));
    }
  }

  /// Метод для парсингу значень Enum та формування Map зіставлення для
  /// поточної програми. Кожен раз, коли налаштування у коді будуть змінені,
  /// буде побудоване нове зіставлення Enum -> String, String -> Enum.
  _parseScenarioEnums(Scenario scenario) {
    for (Enum action in scenario.actions) {
      _mapEnumToString[action] = action.name;
      _mapStringToEnum[action.name] = action;
    }
  }

  /// Метод для конвертації Scenario до придатного для зберігання Property
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
