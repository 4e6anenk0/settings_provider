import 'dart:collection';

import '../../helpers/exceptions.dart';
import '../../interfaces/converter_interface.dart';
import '../base/property.dart';
import 'theme_property.dart';

class ThemePropertyConverter implements IPropertyConverter<ThemeProperty> {
  final HashMap<String, ThemeProperty> themes = HashMap();
  //final HashMap<String, ThemeDesc> themes = HashMap();

  @override
  ThemeProperty convertFrom<V>(V value, ThemeProperty targetProperty) {
    if (themes[targetProperty.defaultValue.themeID] != null) {
      return themes[targetProperty.defaultValue.themeID]!;
    } else {
      throw AdapterExeption('Theme Property not founded!');
    }
  }

  @override
  Property convertTo(ThemeProperty targetProperty) {
    if (targetProperty != themes[targetProperty.defaultValue.themeID]) {
      themes[targetProperty.defaultValue.themeID] = targetProperty;
    }

    return Property(
        defaultValue: targetProperty.defaultValue.themeID,
        id: targetProperty.id,
        isLocalStored: targetProperty.isLocalStored);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, ThemeProperty targetProperty) {
    if (themes[value] != null) {
      return themes[value]!.defaultValue as V2;
    } else {
      throw AdapterExeption('Theme Property not founded!');
    }

    /* if (themes[value] != null) {
      return themes[value]!.defaultValue as V2;
    } else {
      throw AdapterExeption('Theme Property not founded!');
    } */
  }
}
