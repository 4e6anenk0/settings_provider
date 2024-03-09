import '../../helpers/exceptions.dart';
import '../../interfaces/converter_interface.dart';
import '../base/property.dart';
import 'theme_property.dart';

class ThemePropertyConverter implements IPropertyConverter<ThemeProperty> {
  final Map<String, ThemeDesc> _themes = {};
  //final HashMap<String, ThemeDesc> _themes = HashMap();

  @override
  ThemeProperty convertFrom<V>(V value, ThemeProperty targetProperty) {
    if (_themes[value] != null) {
      //return _themes[targetProperty.defaultValue.themeID]!;
      return targetProperty.copyWith(defaultValue: _themes[value]!);
    } else {
      //return getCache(targetProperty);
      throw AdapterExeption('Theme Property not founded!');
    }
    /* if (_themes[value] != null) {
      //return _themes[targetProperty.defaultValue.themeID]!;
      return targetProperty.copyWith(defaultValue: _themes[value]!);
    } else {
      throw AdapterExeption('Theme Property not founded!');
    } */
  }

  @override
  Property convertTo(ThemeProperty targetProperty) {
    if (targetProperty.defaultValue !=
        _themes[targetProperty.defaultValue.themeID]) {
      _themes[targetProperty.defaultValue.themeID] =
          targetProperty.defaultValue;
    }

    return Property(
        defaultValue: targetProperty.defaultValue.themeID,
        id: targetProperty.id,
        isLocalStored: targetProperty.isLocalStored);
  }

  @override
  V2 convertValue<V1, V2>(V1 value, ThemeProperty targetProperty) {
    if (_themes[value] != null) {
      return _themes[value]! as V2;
    } else {
      throw AdapterExeption('Theme Property not founded!');
    }
  }

  @override
  void clearCache() {
    _themes.clear();
  }

  @override
  getCache(ThemeProperty targetProperty) {
    if (_themes[targetProperty.defaultValue.themeID] != null) {
      return _themes[targetProperty.defaultValue.themeID]!;
    } else {
      _themes[targetProperty.defaultValue.themeID] =
          targetProperty.defaultValue;
      return _themes[targetProperty.defaultValue.themeID];
    }
  }

  @override
  void preset<V>(
      {required ThemeProperty targetProperty,
      required String id,
      required V data}) {
    assert(data is ThemeDesc);
    _themes[id] = data as ThemeDesc;
  }
}
