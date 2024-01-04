import '../properties/base/property.dart';

abstract interface class IConverter<T extends BaseProperty> {
  Property convertTo(T targetProperty);
  T convertFrom<V>(V value, BaseProperty targetProperty);
  V2 convertValue<V1, V2>(V1 value, BaseProperty targetProperty);
}
