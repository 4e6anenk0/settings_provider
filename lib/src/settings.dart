import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:settings_provider/settings_provider.dart';
import 'package:settings_provider/src/helpers/exceptions.dart';
import 'package:settings_provider/src/storages/storage.dart';
import 'interfaces/settings_controller_interface.dart';
import 'property_converter.dart';

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
class Settings<T extends BaseSettingsModel> extends StatefulWidget {
  const Settings({super.key, required this.model, required this.child});

  final Widget child;

  final T model;

  /// The static `of()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// The `listen = true` option allows you to subscribe to changes in settings.
  /// But we should use the method with this parameter only in the context of the widget tree
  /// or in the `didChangeDependencies()` method.
  @Deprecated(
      'This method was split into two separate methods. For listening: `listenFrom()`, and for unsubscribed access `from()`.')
  static T of<T extends BaseSettingsModel>(BuildContext context,
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

  /// The static `listenFrom()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// This method allows you to subscribe to changes in settings.
  /// But we should use the method with this parameter only in the context of the widget tree
  /// or in the `didChangeDependencies()` method.
  static T listenFrom<T extends BaseSettingsModel>(BuildContext context) {
    SettingsNotifier<T>? provider =
        context.dependOnInheritedWidgetOfExactType<SettingsNotifier<T>>();
    if (provider == null && null is! T) {
      throw Exception(
          'Not founded provided Settings or Config. You may have forgotten to specify the type of settings class from which you are trying to get settings');
    }
    return provider?.notifier as T;
  }

  /// The static `from()` method allows you to look up the implemented SettingsNotifier
  /// that stores the controller to interact with settings.
  ///
  /// This method allows you to get setting from settings.
  static T from<T extends BaseSettingsModel>(BuildContext context) {
    SettingsNotifier<T>? provider =
        context.getInheritedWidgetOfExactType<SettingsNotifier<T>>();
    if (provider == null && null is! T) {
      throw Exception(
          'Not founded provided Settings or Config. You may have forgotten to specify the type of settings class from which you are trying to get settings');
    }
    return provider?.notifier as T;
  }

  @override
  State<Settings<T>> createState() => _SettingsState<T>();
}

class _SettingsState<T extends BaseSettingsModel> extends State<Settings<T>> {
  @override
  Widget build(BuildContext context) {
    return SettingsNotifier(
      notifier: widget.model,
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
abstract class SettingsModel extends BaseSettingsModel {
  List<BaseProperty> get properties;
  List<ISettingsStorage>? get storages => null;
  String get id => runtimeType.toString();
  bool get isDebug => false;
  ThemeProperty<ThemeDesc>? get defaultTheme => null;
  bool get useEmptySettingsStorage => false;

  @override
  PropertyConverter get converter => _converter;

  @override
  ISettingsController get controller => _controller;

  @override
  SettingsStorage get storage => _storage;

  @override
  ThemeProperty<ThemeDesc> get theme =>
      defaultTheme ??
      ThemeProperty(
        defaultValue: ThemeDesc(
          lightTheme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeID: 'defaultTheme',
        ),
        id: 'defaultTheme',
        isLocalStored: true,
      );

  late final SettingsController _controller;
  late final SettingsStorage _storage;
  final PropertyConverter _converter = PropertyConverter();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    _storage = useEmptySettingsStorage
        ? SettingsStorage.getEmpty()
        : SettingsStorage.getInstance();

    try {
      if (_storage.isNotInitialized) {
        await _storage.init();
      }

      _controller = await SettingsController.consist(
        converter: _converter,
        properties: properties,
        prefix: id,
        storages: storages,
        isDebug: isDebug,
      );

      _isInitialized = true;
    } catch (e) {
      throw InitializationError(model: runtimeType.toString());
    }
  }

  @override
  T get<T>(BaseProperty<T> property) {
    return _controller.get(property);
  }

  @override
  Future<void> update<T>(BaseProperty<T> property) async {
    await _controller.update(property);
    notifyListeners();
  }

  @override
  Future<void> setForLocal<T>(BaseProperty property) async {
    await _controller.setForLocal(property);
  }

  @override
  void setForSession<T>(BaseProperty property) {
    _controller.setForSession(property);
    notifyListeners();
  }

  @override
  Future<void> match() async {
    await _controller.match();
  }

  @override
  Map<String, Object> getAll() {
    return _controller.getAll();
  }
}

abstract class BaseSettingsModel extends ChangeNotifier
    implements ISettingsController {
  BaseSettingsModel();

  PropertyConverter get converter;
  ISettingsController get controller;
  SettingsStorage get storage;
  ThemeProperty get theme;
}

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
