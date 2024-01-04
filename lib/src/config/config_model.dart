import '../../settings_provider.dart';
import '../helpers/settings_controller_interface.dart';
import '../property_converter.dart';

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
  List<BaseProperty> get properties;
  List<ConfigPlatform> get platforms;
  List<ISettingsStorage>? get settingsStorages => null;
  String get id => runtimeType.toString();

  @override
  PropertyConverter get propertyConverter => _converter;

  @override
  ISettingsController get controller => _controller;

  late final SettingsController _controller;
  late final PropertyConverter _converter;

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
        _converter = PropertyConverter();
        //_converter.registerAdapter(EnumPropertyConverter(), 'EnumProperty');
        _controller = await SettingsController.consist(
            properties: properties,
            prefix: id,
            storages: settingsStorages,
            converter: _converter);
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
  T get<T>(BaseProperty<T> property) {
    return _controller.get(property);
  }

  @override
  Future<void> update<T>(BaseProperty<T> property) async {
    await _controller.update(property);
    notifyListeners();
  }

  @override
  Future<void> setForLocal<T>(BaseProperty property) async {
    await _controller.setForLocal(property);
  }

  @override
  void setForSession<T>(BaseProperty property) {
    _controller.setForSession(property);
    notifyListeners();
  }

  @override
  Future<void> match() async {
    await _controller.match();
  }

  @override
  Map<String, Object> getAll() {
    return _controller.getAll();
  }
}
