import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:settings_provider/src/helpers/exceptions.dart';
import 'package:settings_provider/src/properties/theme/theme_property.dart';

import '../../interfaces/converter_interface.dart';
import '../base/property.dart';

class ThemePropertyConverter implements IPropertyConverter<ThemeProperty> {
  final HashMap<String, ThemeData> themes = HashMap();

  @override
  ThemeProperty<ThemeData> convertFrom<V>(
    V value,
    BaseProperty targetProperty,
  ) {
    if (targetProperty is ThemeProperty) {
      return targetProperty.copyWith(defaultValue: themes[value]);
    } else {
      throw AdapterExeption("Cannot convert value for invalid type!");
    }
  }

  @override
  Property convertTo(ThemeProperty<ThemeData> targetProperty) {
    if (!themes.containsKey(targetProperty.id)) {
      themes[targetProperty.id] = targetProperty.defaultValue;
    }
    return Property(
        defaultValue: targetProperty.id,
        id: targetProperty.id,
        isLocalStored: targetProperty.isLocalStored);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty) {
    return themes[value] as V2;
  }
}
