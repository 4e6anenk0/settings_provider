import 'package:flutter/material.dart';
import 'package:settings_provider/src/properties/theme/theme_property.dart';

import '../../interfaces/converter_interface.dart';
import '../base/property.dart';

/* class ThemePropertyConverter implements IPropertyConverter<ThemeProperty> {
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
  Property convertTo(ThemeProperty<ThemeData> targetProperty) {
    return Property(
        defaultValue: targetProperty.id,
        id: targetProperty.id,
        isLocalStored: targetProperty.isLocalStored);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty) {
    var parsed = _parse(targetProperty as EnumProperty);
    return parsed[value] as V2;
  }
}
 */