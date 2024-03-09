import '../properties/base/property.dart';

abstract interface class IPropertyConverter<T extends BaseProperty> {
  /// Convert the specific property to a generic Property type
  Property convertTo(T targetProperty);

  /// Convert the value of the generic type to the specific property
  T convertFrom<V>(V value, T targetProperty);

  /// Convert a value of a generic type to the specific value of another property
  V2 convertValue<V1, V2>(V1 value, T targetProperty);

  /// Get the value from the cache. A cache usually stores data that is
  /// an intermediate state between a Property and a specific property.
  /// This data that allows you to match a Property with a specific property
  /// by some identifier
  getCache(T targetProperty);

  /// Deletes all cache in the converter
  void clearCache();

  /// This method helps to dynamically set the data to fill in the converter.
  ///
  /// This can be useful, for example, when we have some data that should already
  /// be in the converter at the time of initialization of the settings.
  /// For example, theme values that are not separate properties, but these values
  /// are used for the theme property, which is already built into this library
  /// in the theme_hook subpackage. That is, in the usual case, for the value
  /// to get into the converter, it must be part of the property and initialized
  /// before the construction of the App() class
  void preset<V>(
      {required T targetProperty, required String id, required V data});
}
