import '../properties/base/property.dart';

abstract interface class IPropertyConverter<T extends BaseProperty> {
  Property convertTo(T targetProperty);
  T convertFrom<V>(V value, T targetProperty);
  V2 convertValue<V1, V2>(V1 value, T targetProperty);
}
