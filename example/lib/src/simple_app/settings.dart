import 'package:settings_provider/settings_provider.dart';

const isDarkMode = Property<bool>(
  defaultValue: false,
  id: 'isDarkMode',
  isLocalStored: true,
);

const counterScaler =
    Property<int>(defaultValue: 1, id: 'counterScaler', isLocalStored: true);

List<Property> settings = [isDarkMode, counterScaler];
