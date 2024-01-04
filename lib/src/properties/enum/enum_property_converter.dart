import '../../helpers/converter_interface.dart';
import '../base/property.dart';
import 'enum_property.dart';

/// A class for managing `Enum` settings through `EnumProperty` properties.
///
/// Implements an extension over the base `SettingsController` class for `Property`.
class EnumPropertyConverter implements IConverter<EnumProperty> {
  Map<String, Enum> _parse(EnumProperty<Enum> property) {
    var parsed = <String, Enum>{};
    for (Enum value in property.values) {
      parsed[value.name] = value;
    }
    return parsed;
  }

  @override
  EnumProperty<Enum> convertFrom<V>(V value, BaseProperty targetProperty) {
    var parsed = _parse(targetProperty as EnumProperty);
    return targetProperty.copyWith(defaultValue: parsed[value]);
  }

  @override
  Property convertTo(EnumProperty<Enum> targetProperty) {
    return Property(
        defaultValue: targetProperty.defaultValue.name,
        id: targetProperty.id,
        isLocalStored: targetProperty.isLocalStored);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty) {
    var parsed = _parse(targetProperty as EnumProperty);
    return parsed[value] as V2;
  }
}
