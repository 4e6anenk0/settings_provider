import '../base/property.dart';

/// A class for building settings associated with Enum values.
///
/// EnumProperty can be treated as a Property. It can also be accessed through
/// methods similar to those in a standard Property. The difference is its
/// ability to handy use Enum in a local storage for re-mapping with
/// the corresponding Enum after inited new session.
/// With the EnumPropertyBuilder, dynamic configurations that depend on Enum can be
/// easily created.
class EnumProperty<T extends Enum> extends BaseProperty<T> {
  const EnumProperty({
    required this.values,
    required super.defaultValue,
    required super.id,
    bool? isLocalStored,
  }) : super(isLocalStored: isLocalStored ?? false);

  final List<T> values;

  EnumProperty<T> copyWith({
    List<T>? values,
    T? defaultValue,
    bool? isLocalStored,
  }) {
    return EnumProperty(
      values: values ?? this.values,
      defaultValue: defaultValue ?? this.defaultValue,
      id: id,
      isLocalStored: isLocalStored ?? this.isLocalStored,
    );
  }

  @override
  String get type => 'EnumProperty';
}
