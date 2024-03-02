import '../properties/base/property.dart';

abstract interface class IPropertyConverter<T extends BaseProperty> {
  Property convertTo(T targetProperty);
  T convertFrom<V>(V value, T targetProperty);
  V2 convertValue<V1, V2>(V1 value, T targetProperty);
  getCache(T targetProperty);
  void clearCache();
  void preset<V>(
      {required T targetProperty, required String id, required V data});
}
