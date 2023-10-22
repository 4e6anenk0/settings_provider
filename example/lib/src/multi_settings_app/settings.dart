import 'package:settings_provider/settings_provider.dart';

const Property<bool> isDarkMode = Property(
  defaultValue: false,
  id: 'isDarkMode',
  isLocalStored: true,
);

const Property<int> counterScaler =
    Property(defaultValue: 1, id: 'counterScaler');

List<Property> settings = [isDarkMode, counterScaler];

const Property<String> name = Property(defaultValue: 'John', id: 'name');

List<Property> personalSettings = [name];
