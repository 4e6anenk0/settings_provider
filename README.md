# Settings Provider

<p align="center">
    <img width=200 height=200 src="https://github.com/4e6anenk0/settings_provider/blob/main/img/logo-2.png?raw=true" alt="Logo">
</p>

A library for providing declarative configuration of app settings.

## Features

- Description of configuration settings using declarative properties;
- It is convenient to separate settings from the project;
- Handy methods and helper functions to manage settings;
- Ability to react UI to changes in settings and receive settings from the context;
- Use the `Setting` widget to easily provide settings in your project.
- Use the `Scenario` properties for the Enums and `ScenarioBuilder` to build the appropriate UI;
- Use `Config` and `ConfigBuilder` to group settings by platform and use the groups of settings depending on the platform.

If you need the simplest implementation, read about the `Settings` widget:

- [More about Settings widget ...](https://github.com/4e6anenk0/settings_provider#1-the-settings-widget-class-example-of-the-simplest-usage)

If you want the most flexible and powerful solution, see about `Config` and `ConfigBuilder`:

- [More about Config and ConfigBuilder widgets ...](https://github.com/4e6anenk0/settings_provider#4-the-configmodel-property-class-with-configbuilder-or-config-widget-class-example-of-usage)

If you need to store the Enum locally and the last value to build the appropriate UI, then see more about the Scenario property:

- [More about Scenario property ...](https://github.com/4e6anenk0/settings_provider#3-the-scenario-property-class-with-scenariobuilder-widget-class-example-of-usage)

Also visit pub.dev:

<div align="center">

<div>
  <a href="https://pub.dev/packages/settings_provider">
      <img width="235" src="https://github.com/4e6anenk0/settings_provider/blob/main/img/pubdev.png?raw=true" alt="Logo">
  </a>
</div>
</div>

## Quick start. Example

### Simple usage with SettingsModel

1) settings.dart:

```dart
class GeneralSettings extends SettingsModel {
  @override
  List<Property> get properties => [isDarkMode, counterScaler];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static const Property<int> counterScaler =
      Property(defaultValue: 1, id: 'counterScaler', isLocalStored: true);
}
```

2) main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var generalSettings = GeneralSettings();

  await generalSettings.init();

  runApp(
    Settings(
      model: generalSettings,
      child: const SimpleApp(),
    ),
  );
}
```

2) access to the settings:

```dart
// get setting without subscription
context.setting<GeneralSettings>().get(property);
// or
Settings.from<GeneralSettings>(context).get(property);

// get setting with subscription
context.listenSetting<GeneralSettings>().get(property);
// or
Settings.listenFrom<GeneralSettings>(context).get(property);

// update setting
context.setting<GeneralSettings>().update(property);
// or 
Settings.from<GeneralSettings>(context).update(property);
```

### More functionality usage with ConfigModel

1) settings.dart:

```dart
class GeneralConfig extends ConfigModel {
  @override
  List<ConfigPlatform> get platforms => [ConfigPlatform.general];

  @override
  List<Property> get properties => [isDarkMode, counterScaler, name];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static const Property<int> counterScaler = Property(
    defaultValue: 1,
    id: 'counterScaler',
    isLocalStored: false,
  );

  static const Property<String> name = Property(
    defaultValue: "Jonh",
    id: 'name',
    isLocalStored: false,
  );
}
```

2) main.dart:

```dart
void main() async {
  var generalConfig = GeneralConfig();

  await generalConfig.init();

  runApp(
    Config(
      providers: [
        SettingsProvider(
          model: generalConfig,
        ),
      ],
      child: ConfigAppForWeb(),
    ),
  );
}
```

3) access to the settings:

```dart
// get setting without subscription
context.setting<GeneralConfig>().get(property);
// or
Config.from<GeneralConfig>(context).get(property);

// get setting with subscription
context.listenSetting<GeneralConfig>().get(property);
// or
Config.listenFrom<GeneralConfig>(context).get(property);

// update config
context.setting<GeneralConfig>().update(property);
// or 
Config.from<GeneralConfig>(context).update(property);
```

<div align="center">

<div>
  <a href="https://pub.dev/packages/settings_provider">
      <img width="235" src="https://github.com/4e6anenk0/settings_provider/blob/main/img/pubdev.png?raw=true" alt="Logo">
  </a>
</div>
<div>
  <a href="https://www.buymeacoffee.com/yppppl" target="_blank">
    <img width="200" src="https://cdn.buymeacoffee.com/buttons/default-yellow.png" alt="Buy Me A Coffee ❤️">
  </a>
</div>
</div>

## Getting started

The `settings_provider` library implements several concepts that are familiar to Flutter developers. Let's get acquainted with the concept of the library in a little more detail.

The `settings_provider` separates settings into local settings (delegated to the Shared Preference storage or other local storage) and equivalent current session settings. The `settings_provider` tries to keep settings synchronized between these levels. For this, the entire configuration is described in `Property()` objects, which are immutable, constant and declarative. Also, `settings_provider` automatically creates the required settings both locally (optionaly) and in the current session.

All interaction with the settings happens through the `SettingsController`. All interaction with the scenarios happens through the `ScenarioController`.

## Usage

### 1. The `Settings()` widget class. Example of the simplest usage

#### 1.1. Property

To create a configuration, the package provides a `Property()` class that allows you to create a declarative configuration of settings.

**Property only describes the setting and does not have to match your current or local settings configuration.** This means you need only care about the default value in you app and whether this value should be stored in local storage (SharedPreferences by default).

For example, create the first property:

```dart
const counterScaler = Property(
    defaultValue: 1, 
    id: 'counterScaler', 
    isLocalStored: true,
);
```

`defaultValue` - the default value. It also specifies the type for the property.

`id` - key for value or name. It's better to call it the same as the variable.

`isLocalStored` - parameter that indicates whether data should be stored in local storage. Optional parameter. The default value is `false`.

#### 1.2. Settings widget

In order to use the package in your project, you need to wrap the application creation function in `Settings()` widget at the top level. This will allow you to get the configuration before the application UI starts rendering. This is necessary for consistent creation of the app, so that the configuration of the session matches the data of the local storage.

The `Settings()` widget is responsible for implementing settings in the widget tree. To implement settings, you need to create a class based on `SettingsModel` and initialize this class asynchronously using the `init()` method:

```dart
var generalSettings = GeneralSettings();

await generalSettings.init();
```

Main function example:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var generalSettings = GeneralSettings();

  await generalSettings.init();

  runApp(
    Settings(
      model: generalSettings,
      child: const SimpleApp(),
    ),
  );
}
```

#### 1.3. Access to the settings

Once the settings have been implemented, you can refer to them to get them or update the values.

To do this, you need to refer to the static function `from<T>()` or `listenFrom<T>()`, which is available in the Settings class, and find the desired method to pass the property. You must specify the type of model you created previously, otherwise you will not be able to find your settings:

```dart
Settings.from<T>(context).get(property);
```

or:

```dart
Settings.listenFrom<T>(context).get(property);
```

A logical question arises... Do you need to create a new property with similar settings every time when you make a change to the settings? **Yes, but you don't have to do it yourself ever.**

If you want to make a change in your settings, you need to use the `copyWith()` method, which is well known to Flutter developers. For example, look how simple it is:

```dart
Settings.from(context).update(property.copyWith(defaultValue: newValue));
```

Here are the methods available to you for working with the settings:

```dart
  // 1
  Future<void> update<T>(Property<T> property);
  // 2
  T get<T>(Property<T> property);
  // 3
  void setForSession<T>(Property property);
  // 4
  Future<void> setForLocal<T>(Property property);
  // 5
  Future<void> match();
  // 6
  Map<String, Object> getAll(); 
```

1) `update(property)` - to update setting values both locally (if `true`) and for the current session;
2) `get(property)` - to get the setting value;
3) `setForSession(property)` - to set the value in the current session. This has no effect on saving the value in local storage, but causes listeners to be notified of the change in setting. This can be useful for changes only in the current session to a value that is stored locally, or for deferred saving to reduce the number of local storage accesses
4) `setForLocal(property)` - sets the value for local storage only. Changes will be synchronized only after restarting the application (in a new session)
5) `match()` - update (synchronization) of all the data of the current session with the data of the local storage. Relevant for making changes after calls to setForSession()
6) `getAll()` - returns Map() of all settings relevant for the current session

#### 1.4. Helpers for access to settings

For convenience, the library implements helpers functions for accessing settings. These are available via `context` references and make it even easier to work with a simple `Settings()`.

Example:

```dart
context.setting<T>().get(property);
```

Instead:

```dart
Settings.from<T>(context).get(property);
```

Or:

```dart
context.listenSetting<T>().get(property);
```

Instead:

```dart
Settings.listenFrom(context).get(property);
```

Choose what is more convenient for you.

### 2. The `MultiSettings()` widget class. Example of the group usage

The library also provides the ability to create separate groups of settings. They will have separate areas of responsibility, that is, they will have their own controller and notification system. Next, we will go through the steps that must be taken in order to use this option in your project:

2.1. Let's create separate configurations from properties:

First configuration:

```dart
class FirstSettings extends SettingsModel {
  @override
  List<Property> get properties => [isDarkMode, counterScaler];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static const Property<bool> isDarkMode = Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static const Property<int> counterScaler =
      Property(defaultValue: 1, id: 'counterScaler');
}
```

Second configuration:

```dart
class SecondSettings extends SettingsModel {
  @override
  List<Property> get properties => [name];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  static const Property<String> name =
      Property(defaultValue: 'John', id: 'name');
}
```

2.2. Let's create models for our property groups (to locate them in the tree) and initialize them:

```dart
var firstSettings = FirstSettings();
var secondSettings = SecondSettings();

await firstSettings.init();
await secondSettings.init()
```

2.3. Let's implement settings through MultiSettings() and a special class for nested settings SettingsProvider():

```dart
runApp(
    MultiSettings(
      providers: [
        SettingsProvider(model: firstSettings),
        SettingsProvider(model: secondSettings),
      ],
      child: const MultiSettingsApp(),
    ),
  );
```

2.4 Access to settings in MultiSettings

```dart
Settings.from<FirstSettings>(context).get(counterScaler);

Settings.from<SecondSettings>(context).get(name);

// or

context.setting<FirstSettings>().get(counterScaler);

context.setting<SecondSettings>().get(name);
```

### 3. The `Scenario()` property class with `ScenarioBuilder()` widget class. Example of usage

The Scenario() class is inherited from the Property() class. So, it can be considered that scenarios are similar to properties. Yes, although scenarios share many commonalities, they can't be processed without converting them to properties. This is the task of the ScenarioController(), which parses enums and transforms them to strings, creating mappings (Enum -> String) or (String -> Enum) for the current session of the app, and it creates a set of properties to be passed to the SettingsController().

#### 3.1. The `Scenario()` property

Let's create scenario property:

```dart
Scenario<ThemeMode> themeMode =
    Scenario(
      actions: ThemeMode.values, 
      defaultValue: ThemeMode.dark
    );
```

In our example, we use the standard Enum from the Flutter library known as the `ThemeMode`.

As you can see, scenarios are very similar to properties. Unlike Property(), we should pass the parameter `actions`, which is of type `List<Enum>`. To get a list of enums you should call `Enum.values`. But the id parameter shouldn't be passed.

#### 3.2. Create a class based on SettingsModel with scenarios

```dart
class GeneralSettings extends SettingsModel {
  
  ...

  @override
  List<Scenario<Enum>>? get scenarios => [themeMode];

  ...

  static Scenario<ThemeMode> themeMode =
      Scenario(actions: ThemeMode.values, defaultValue: ThemeMode.dark);
}
```

The general main() function would look like this:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var generalSettings = GeneralSettings();

  await generalSettings.init();

  runApp(
    Settings(
      model: generalSettings,
      child: const ScenarioApp(),
    ),
  );
}
```

#### 3.3. Use a ScenarioBuilder to build a UI that depends on the Enum value

```dart
class ScenarioApp extends StatelessWidget {
  const ScenarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScenarioBuilder<ThemeMode, GeneralSettings>(
      builder: (context, action) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: '/',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: action,
          home: const MyHomePage(title: 'Setting Scenario Example'),
        );
      },
      scenario: GeneralSettings.themeMode,
    );
  }
}
```

Consider `ScenarioBuilder<T, P>()` individually:

```dart
ScenarioBuilder<ThemeMode, GeneralSettings>(
      builder: (context, action) {
        return MaterialApp(
          ...
          themeMode: action,
          ...
        );
      },
      scenario: GeneralSettings.themeMode,
    );
```

As we can see, using Enum to build a dependent UI is quite simple. The `ScenarioBuilder()` class has its own builder that accepts `context` and `action`. The `action` itself is the Enum value we need and can use. And the `scenario` parameter accepts the `Scenario()` property on which the specific `ScenarioBuilder()` depends.

#### Why is it called Scenario?

Why is it called "Scenario"? Scenarios characterize a sequence of actions according to a role. Each Enum value is unique in the context of building a unique configuration and associated UI. Therefore, a limited set of Enum values creates a specific set of configurations, making it a kind of distinct "scenario." Additionally, Scenario() can be used within the ConfigBuilder() class, which provides a way to build the SettingsController() with the corresponding set of related properties that depend on the Enum value in ConfigBuilder. This concept also resembles the notion of execution scenarios.

### 4. The `ConfigModel()` property class with `ConfigBuilder()` or `Config()` widget class. Example of usage

This is the most automatic solution, where implementation and access to settings.

To do this, it is enough to create a class that based on ConfigModel:

```dart
class MyConfig extends ConfigModel {
  ...
}
```

You will need to implement get methods to obtain the necessary configuration data:

```dart
class MyConfig extends ConfigModel {

  @override
  List<ConfigPlatform> get platforms => throw UnimplementedError();

  @override
  List<Property> get properties => throw UnimplementedError();

  @override
  List<Scenario<Enum>>? get scenarios => throw UnimplementedError();

  ...
}
```

Also, for convenience, you can add properties inside this class, making the fields static:

```dart
class MyConfig extends ConfigModel {

  @override
  List<ConfigPlatform> get platforms => [ConfigsPlatform.general];

  @override
  List<Property> get properties => [isDarkMode, counterScaler, name];

  @override
  List<Scenario<Enum>>? get scenarios => null;

  ...

  static Property<bool> isDarkMode = const Property(
    defaultValue: false,
    id: 'isDarkMode',
    isLocalStored: true,
  );

  static Property<int> counterScaler = const Property(
    defaultValue: 1,
    id: 'counterScaler',
    isLocalStored: false,
  );

  static Property<String> name = const Property(
    defaultValue: "John",
    id: 'name',
    isLocalStored: false,
  );
}
```

Now you can conveniently access the required group of settings as follows:

```dart
MyConfig.name;
```

Another advantage of this approach is that you can create different settings configurations with the same fields:

```dart
class MyConfig1 extends ConfigModel {

  ...

  static Property<String> name = const Property(
    defaultValue: "John",
    id: 'name',
    isLocalStored: false,
  );
}

class MyConfig2 extends ConfigModel {

  ...

  static Property<String> name = const Property(
    defaultValue: "Test user",
    id: 'name',
    isLocalStored: false,
  );
}
```

And to have access to the necessary settings as follows:

```dart
MyConfig1.name;
MyConfig2.name;
```

To implement the configuration, you can use one of the following widgets:

1. Config
2. ConfigBuilder

The `Config` - only allows you to inject configuration into the widget tree. The `ConfigBuilder` allows you to build the required UI based on the target platform.

1. Config:

```dart
var generalConfig = GeneralConfig();
var webConfig = WebConfig();

await generalConfig.init();
await webConfig.init();

runApp(
    Config(
      providers: [
        SettingsProvider(
          model: generalConfig,
        ),
        SettingsProvider(
          model: webConfig,
        )
      ],
      child: ConfigAppForWeb(),
    ),
  );
```

2. ConfigBuilder:

```dart
var generalConfig = GeneralConfig();
var webConfig = WebConfig();

await generalConfig.init();
await webConfig.init();

runApp(
    ConfigBuilder(
      providers: [
        SettingsProvider(
          model: generalConfig,
        ),
        SettingsProvider(
          model: webConfig,
        )
      ],
      builder: (context, platform) {
        if (platform == ConfigPlatform.web) {
          return const ConfigAppForWeb();
        } else {
          return const ConfigApp();
        }
      },
    ),
  );
```

## Additional information

I will be very glad for your active participation in the discussion, support and development of this library.

## Roadmap

Tasks that still need to be solved:

- [ ] - Implementation of file local storage for settings
- [ ] - Writing some basic tests and thoroughly analyzing the code for possible problems
- [ ] - Support settings from `.env` file
- [ ] - Support settings from `json` and `yaml` files
- [ ] - Writing instructions for creating own data stores (for example, for network settings)
- [ ] - Consider possible separation of settings_provider from Flutter
