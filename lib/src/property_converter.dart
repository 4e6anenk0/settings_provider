import 'helpers/converter_interface.dart';
import 'helpers/exceptions.dart';
import 'properties/base/property.dart';
import 'properties/enum/enum_property_converter.dart';

class PropertyConverter implements IConverter {
  final Map<String, IConverter> _converters = {
    'Property': BasePropertyConverter(),
    'EnumProperty': EnumPropertyConverter(),
  };

  void registerConverter(
      {required IConverter converter, required String propertyTypeID}) {
    _converters[propertyTypeID] = converter;
  }

  IConverter getConverter(BaseProperty property) {
    if (property is Property) {
      return BasePropertyConverter();
    } else {
      var adapter = _converters[property.type];

      if (adapter == null) {
        throw AdapterExeption(
            """The adapter for this type was not registered with PropertyAdapter. 
You can't get the adapted controller the from _getAdaptedController method""");
      } else {
        return adapter;
      }
    }
  }

  @override
  BaseProperty convertFrom<V>(V value, BaseProperty targetProperty) {
    var converter = getConverter(targetProperty);
    return converter.convertFrom(value, targetProperty);
  }

  @override
  Property convertTo(BaseProperty targetProperty) {
    var converter = getConverter(targetProperty);
    return converter.convertTo(targetProperty);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty) {
    var converter = getConverter(targetProperty);
    return converter.convertValue(value, targetProperty);
  }
}

class BasePropertyConverter implements IConverter {
  @override
  BaseProperty convertFrom<V>(V value, BaseProperty targetProperty) {
    return targetProperty;
  }

  @override
  Property convertTo(BaseProperty targetProperty) {
    return targetProperty as Property;
  }

  @override
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty) {
    return value as V2;
  }
}
