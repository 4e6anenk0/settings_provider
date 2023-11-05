import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

import 'helpers/settings_controller_interface.dart';
import 'scenarios/scenario.dart';
import 'scenarios/scenario_controller.dart';
import 'settings_controller.dart';
import 'settings_property.dart';

/// Widget for implementing settings in the widget tree. It uses SettingsNotifier
/// for implementation and SettingsModel for settings change notifications.
/// Given the importance of having top-level settings, it's better to wrap the
/// MaterialApp widget in Settings to make the settings global to our app,
/// or wrap the app's build method altogether.
///
/// For example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   SettingsController controller =
///      await SettingsController.consist(propertyes: settings);
///
///  runApp(
///    Settings(
///      controller: controller,
///      child: const SimpleApp(),
///    ),
///  );
///}
/// ```
class Settings extends StatefulWidget {
  const Settings(
      {super.key,
      required this.settingsController,
      this.scenarioController,
      required this.child});

  final Widget child;

  /// A controller is required to manage settings
  final SettingsController settingsController;

  final ScenarioController? scenarioController;

  /// The static `of()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// The `listen = true` option allows you to subscribe to changes in settings.
  /// But we should use the method with this parameter only in the context of the widget tree
  /// or in the `didChangeDependencies()` method.
  static T of<T extends SettingsModel>(BuildContext context,
      {bool listen = false}) {
    if (listen == true) {
      SettingsNotifier<T>? provider =
          context.dependOnInheritedWidgetOfExactType<SettingsNotifier<T>>();
      if (provider == null && null is! T) {
        throw Exception('Not founded provided Settings');
      }
      return provider?.notifier as T;
    } else {
      SettingsNotifier<T>? provider =
          context.getInheritedWidgetOfExactType<SettingsNotifier<T>>();
      if (provider == null && null is! T) {
        throw Exception('Not founded provided Settings');
      }
      return provider?.notifier as T;
    }
  }

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final model = SettingsModel(
    settingsController: widget.settingsController,
    scenarioController: widget.scenarioController,
  );

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsNotifier(
      notifier: model,
      child: widget.child,
    );
  }
}

/// A class that inherits `InheritedNotifier`
/// and serves only to implement `SettingsModel` in the context
class SettingsNotifier<T extends BaseSettingsModel>
    extends InheritedNotifier<T> {
  const SettingsNotifier({
    super.key,
    required super.child,
    required T super.notifier,
  });
}

/// This class is just a wrapper over `SettingsController` and implements the
/// same interface as `SettingsController` to manage the controller calls
/// and notify listeners via `ChangeNotifier`
class SettingsModel extends BaseSettingsModel {
  SettingsModel({required settingsController, scenarioController})
      : _settingsController = settingsController,
        _scenarioController = scenarioController;

  final SettingsController _settingsController;
  final ScenarioController? _scenarioController;

  ScenarioController? get scenarioController => _scenarioController;
  SettingsController get settingsController => _settingsController;

  @override
  T get<T>(Property<T> property) {
    if (scenarioController != null && property is Scenario) {
      return scenarioController!.get(property);
    }
    return settingsController.get(property);
  }

  @override
  Future<void> update<T>(Property<T> property) async {
    if (scenarioController != null && property is Scenario) {
      scenarioController!.update(property);
      notifyListeners();
    } else {
      await settingsController.update(property);
      notifyListeners();
    }
  }

  @override
  Future<void> setForLocal<T>(Property property) async {
    if (scenarioController != null && property is Scenario) {
      await scenarioController!.setForLocal(property);
    } else {
      await settingsController.setForLocal(property);
    }
  }

  @override
  void setForSession<T>(Property property) {
    if (scenarioController != null && property is Scenario) {
      scenarioController!.setForSession(property);
      notifyListeners();
    } else {
      settingsController.setForSession(property);
      notifyListeners();
    }
  }

  @override
  Future<void> match() async {
    if (scenarioController != null) {
      await scenarioController!.match();
    } else {
      await settingsController.match();
    }
  }

  @override
  Map<String, Object> getAll() {
    return settingsController.getAll();
  }
}

abstract class BaseSettingsModel extends ChangeNotifier
    implements ISettingsController {}

/// Need to provide Settings in MultiSettings. A class that helps to nest `SettingsNotifier` inside each other
/// with corresponding unique `SettingsModel` models to enable separation of settings
/// into separate areas of responsibility and a corresponding separate notification system
/// for each settings model.
///
/// The `model` parameter must receive a model that is a descendant of the `SettingsModel` class.
/// To do this, create your own class that follows the corresponding class, for example:
/// ```dart
/// class HomeScreenSettings extends SettingsModel {
///  HomeScreenSettings(super.controller);
///}
/// ```
class SettingsProvider<T extends BaseSettingsModel>
    extends SingleChildStatefulWidget {
  const SettingsProvider({required this.model, super.key});

  /// A separate unique instance of the SettingsModel class that allows you
  /// to use SettingsController for a group of unique settings in the form of
  /// a separate SettingsData
  final T model;

  @override
  State<SettingsProvider<T>> createState() => _SettingsProviderState<T>();
}

class _SettingsProviderState<T extends BaseSettingsModel>
    extends SingleChildState<SettingsProvider<T>> {
  late final T model = widget.model;

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return SettingsNotifier(notifier: model, child: child!);
  }
}

/// Widget for implementing settings divided into areas of responsibility.
/// You must have separate lists of `properties` to implement the settings.
///
/// Usage example:
/// ```dart
///// create two settings models
///
///class FirstScreenSettings extends SettingsModel {
///  FirstScreenSettings(super.controller);
///}
///class SecondScreenSettings extends SettingsModel {
///  SecondScreenSettings(super.controller);
///}
///
///// Now we can create controllers with different settings lists
///
///  SettingsController firstScreenSettingsController =
///      await SettingsController.consist(propertyes: settings);
///
///  SettingsController secondScreenSettingsController =
///      await SettingsController.consist(propertyes: personalSettings);
///
///// And now let's implement our settings in our application
///
///runApp(
///    MultiSettings(
///      providers: [
///        SettingsProvider(model: FirstScreenSettings(firstScreenSettingsController)),
///        SettingsProvider(
///            model: SecondScreenSettings(secondScreenSettingsController)),
///      ],
///      child: const App(),
///    ),
///  );
/// ```
class MultiSettings extends Nested {
  MultiSettings({
    super.key,
    required List<SingleChildWidget> providers,
    required super.child,
  }) : super(
          children: providers,
        );
}
