/// An immutable snapshot instance of updated data.
///
/// Stores data that can only be read from the outside and adds two methods to
/// interact with the data snapshot:
///
/// `get` - to get the data;
///
/// `copyWith` - to create a new data snapshot with a new value.
class SettingsData {
  const SettingsData._({required this.data});

  /// A factory for creating an immutable settings configuration from data
  factory SettingsData({Map<String, Object>? data}) {
    Map<String, Object> map = Map.unmodifiable(data ?? {});
    return SettingsData._(data: map);
  }

  /// immutable data configuration object
  final Map<String, Object> data;

  /// Getting data from the configuration
  T get<T>(String key) {
    T value = data[key] as T;
    return value;
  }

  /// Method for conveniently updating data configuration with new parameters.
  ///
  /// Given an immutable configuration, this method creates a new configuration
  /// from the passed data and returns a new `SettingsData`.
  SettingsData copyWith(String key, Object value) {
    Map<String, Object> newData = Map.from(data);
    newData[key] = value;
    return SettingsData(data: newData);
  }
}
