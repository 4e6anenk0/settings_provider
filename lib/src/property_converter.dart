import 'package:settings_provider/src/properties/theme/theme_property_converter.dart';

import 'interfaces/converter_interface.dart';
import 'helpers/exceptions.dart';
import 'properties/base/property.dart';
import 'properties/enum/enum_property_converter.dart';

class PropertyConverter implements IPropertyConverter {
  /// List of registered converters for converting properties
  /// to the general type of universal properties or the other way around
  final Map<String, IPropertyConverter> _converters = {
    'EnumProperty': EnumPropertyConverter(),
    'ThemeProperty': ThemePropertyConverter(),
  };

  /// A method that will help to register custom converters in an any your projects.
  /// To do this, use this method in the Config or Settings class before initialization
  void registerConverter({
    required IPropertyConverter converter,
    required String propertyTypeID,
  }) {
    _converters[propertyTypeID] = converter;
  }

  /// Method to access the appropriate converter based on the type of the passed property
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

  @override
  void clearCache() {
    for (IPropertyConverter converter in _converters.values) {
      converter.clearCache();
    }
  }

  @override
  getCache(BaseProperty targetProperty) {
    IPropertyConverter converter = getConverter(targetProperty);
    return converter.getCache(targetProperty);
  }

  @override
  void preset<V>(
      {required BaseProperty targetProperty,
      required String id,
      required V data}) {
    IPropertyConverter converter = getConverter(targetProperty);
    converter.preset(targetProperty: targetProperty, id: id, data: data);
  }
}
