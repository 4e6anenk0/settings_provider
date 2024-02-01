import 'package:settings_provider/src/helpers/exceptions.dart';

import '../../interfaces/converter_interface.dart';
import '../base/property.dart';
import 'enum_property.dart';

class EnumPropertyConverter implements IPropertyConverter<EnumProperty> {
  Map<String, Enum> _parse(EnumProperty<Enum> property) {
    var parsed = <String, Enum>{};
    for (Enum value in property.values) {
      parsed[value.name] = value;
    }
    return parsed;
  }

  @override
  EnumProperty<Enum> convertFrom<V>(V value, BaseProperty targetProperty) {
    if (targetProperty is EnumProperty) {
      var parsed = _parse(targetProperty);
      return targetProperty.copyWith(defaultValue: parsed[value]);
    } else {
      throw AdapterExeption('Cannot convert value for invalid type!');
    }
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
