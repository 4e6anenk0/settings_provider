import 'package:settings_provider/settings_provider.dart';

class GeneralSettings extends SettingsModel {
  @override
  List<Property> get properties => [isDarkMode, counterScaler];

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static const Property<int> counterScaler =
      Property(defaultValue: 1, id: 'counterScaler', isLocalStored: true);
}
