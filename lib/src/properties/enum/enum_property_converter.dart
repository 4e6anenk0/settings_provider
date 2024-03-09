import '../../interfaces/converter_interface.dart';
import '../base/property.dart';
import 'enum_property.dart';

class EnumPropertyConverter implements IPropertyConverter<EnumProperty> {
  Map<String, Enum> _parse(EnumProperty property) {
    var parsed = <String, Enum>{};
    for (Enum value in property.values) {
      parsed[value.name] = value;
    }
    return parsed;
  }

  //Map<String, Enum>? _cache;
  final Map<String, Map<String, Enum>> _cache = {};

  @override
  Map<String, Enum> getCache(EnumProperty targetProperty) {
    if (_cache[targetProperty.id] != null) {
      return _cache[targetProperty.id]!;
    } else {
      var cacheForProperty = _parse(targetProperty);
      _cache[targetProperty.id] = cacheForProperty;
      return cacheForProperty;
    }
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  @override
  EnumProperty convertFrom<V>(V value, EnumProperty targetProperty) {
    var cache = getCache(targetProperty);
    return targetProperty.copyWith(defaultValue: cache[value]);
  }

  @override
  Property convertTo(EnumProperty targetProperty) {
    return Property(
        defaultValue: targetProperty.defaultValue.name,
        id: targetProperty.id,
        isLocalStored: targetProperty.isLocalStored);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, EnumProperty targetProperty) {
    var cache = getCache(targetProperty);
    return cache[value] as V2;
  }

  @override
  void preset<V>(
      {required EnumProperty targetProperty,
      required String id,
      required V data}) {
    assert(data is Enum);
    _cache[targetProperty.id]![id] = data as Enum;
  }
}
