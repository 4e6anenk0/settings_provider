import 'package:settings_provider/src/properties/theme/theme_property_converter.dart';

import 'interfaces/converter_interface.dart';
import 'helpers/exceptions.dart';
import 'properties/base/property.dart';
import 'properties/enum/enum_property_converter.dart';

class PropertyConverter implements IPropertyConverter {
  final Map<String, IPropertyConverter> _converters = {
    'EnumProperty': EnumPropertyConverter(),
    'ThemeProperty': ThemePropertyConverter(),
  };

  void registerConverter(
      {required IPropertyConverter converter, required String propertyTypeID}) {
    _converters[propertyTypeID] = converter;
  }

  IPropertyConverter getConverter(BaseProperty property) {
    var adapter = _converters[property.type];

    if (adapter == null) {
      throw AdapterExeption(
          """The adapter for this type was not registered with PropertyAdapter. 
You can't get the adapted controller the from _getAdaptedController method""");
    } else {
      return adapter;
    }
  }

  @override
  BaseProperty convertFrom<V>(V value, BaseProperty targetProperty) {
    if (targetProperty is Property) {
      return targetProperty;
    }
    var converter = getConverter(targetProperty);
    return converter.convertFrom(value, targetProperty);
  }

  @override
  Property convertTo(BaseProperty targetProperty) {
    if (targetProperty is Property) {
      return targetProperty;
    }
    var converter = getConverter(targetProperty);
    return converter.convertTo(targetProperty);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty) {
    if (targetProperty is Property) {
      return value as V2;
    }
    var converter = getConverter(targetProperty);
    return converter.convertValue(value, targetProperty);
  }
}
