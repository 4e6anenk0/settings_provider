abstract class BaseProperty<T> {
  const BaseProperty({
    required this.defaultValue,
    required this.id,
    required this.isLocalStored,
  });

  String get type;

  /// The value that will be used by default
  final T defaultValue;

  /// Setting ID or value key. This is usually the name of the setting
  final String id;

  /// whether to store configuration values in local storage
  /// `true` - yes, `false` - no
  final bool isLocalStored;
}

/// Class for declarative description of app settings.
///
/// Analysis of the implemented list of properties allows you to build a configuration of settings.
/// Therefore, we only retrieve the values from these configurations
/// if we need to restore the default values or if we need to load the default values.
/// In these cases, the defaultValue will be used. In all other cases,
/// the settings values are stored in SettingsData - an immutable object of cached data
class Property<T> extends BaseProperty<T> {
  const Property({
    required super.defaultValue,
    required super.id,
    bool? isLocalStored,
  }) : super(isLocalStored: isLocalStored ?? false);

  @override
  String get type => 'Property';

  /// Utility function that helps to create a new property based on the old one
  /// by changing some values when creating a new object.
  ///
  /// For example:
  /// ```dart
  /// context.updateSetting(counterProperty.copyWith(defaultValue: newValue));
  /// ```
  ///
  /// Given the immutable property, this is useful to use when we need
  /// to update values in our settings. We can use the pre-created settings properties
  /// of our application and change the values in the settings by passing the copied data
  /// with the changes there. This will reduce the risk of error, because otherwise,
  /// we would need to create almost identical objects
  Property<T> copyWith({T? defaultValue, bool? isLocalStored}) {
    return Property(
      defaultValue: defaultValue ?? this.defaultValue,
      id: id,
      isLocalStored: isLocalStored ?? this.isLocalStored,
    );
  }
}
