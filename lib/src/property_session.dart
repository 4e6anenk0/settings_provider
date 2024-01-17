import 'dart:collection';

import 'properties/base/property.dart';

class PropertySession {
  HashMap<String, Object> get settings => _settings;

  final HashMap<String, Object> _settings = HashMap();

  Object? get(BaseProperty property) {
    return _settings[property.id];
  }

  void set(BaseProperty property) {
    _settings[property.id] = property.defaultValue;
  }

  void setFromValue({required Object value, required String id}) {
    _settings[id] = value;
  }

  bool contains(BaseProperty property) {
    return _settings.containsKey(property.id);
  }
}
