# Settings Provider

<p align="center">
    <img src="/img/logo.png" alt="Logo">
</p>

A library for providing declarative configuration of app settings.

## Features

- Description of configuration settings using declarative Properties;
- Minimal work with term parameters. It is enough to describe the configuration only once;
- It is convenient to separate settings from the project;
- Handy methods and helper functions to manage settings;
- Ability to react UI to changes in settings and receive settings from the context with InhertitedNotifier.
- Ability to divide settings into groups via MultiSettings. This allows you to have a separate subscription to the relevant set of settings, which can be useful for performance and convenience in large projects

## Getting started

`settings_provider` implements several concepts that are familiar to both Flutter developers and not only. Let's get acquainted with the concept of the library in a little more detail.

`settings_provider` separates settings into local settings (delegated to the shared_preferences package) and current session settings. `settings_provider` tries to keep settings synchronized between these levels. For this, the entire configuration is described in `Property()` objects, which are immutable, constant and declarative. Also, `settings_provider` automatically creates the required settings both locally and in the current session.

All interaction with the settings happens through the `SettingsController`. Data changes do not occur through data mutation, but through replacement of the SettingsData instance. This is such an immutable Map object that has additional methods for obtaining and setting data in an immutable object.

## Usage

### Settings(). Example of the simplest usage

#### Property

To create a configuration, the package provides a `Property()` class that allows you to create a declarative configuration of settings.

**Property only describes the setting and does not have to match your current or local settings configuration.** This means you need only care about the default value and whether this preference should be stored in local storage (SharedPreferences).

For example:

```dart
const counterScaler = Property(
    defaultValue: 1, 
    id: 'counterScaler', 
    isLocalStored: true,
);
```

`defaultValue` - the default value. It also specifies the type for the property.

`id` - key for value or name. It is better to call it the same as the variable.

`isLocalStored` - parameter that indicates whether data should be stored in local storage. Optional parameter. The default value is `false`.

#### Settings widget

In order to use the package in your project, you need to wrap the application creation function in `Settings()` widget at the top level. This will allow you to get the configuration before the application UI starts rendering. This is necessary for consistent creation of the application, so that the configuration of the session matches the data of the local storage.

The Settings() widget is responsible for implementing settings in the widget tree. To implement settings, you need to create a controller asynchronously using the consit() static function and pass a list of properties as a parameter:

```dart
SettingsController controller =
      await SettingsController.consist(properties: settings);
```

Main function example:

```dart
void main() async {
  // the binding on which Flutter depends must be done as a matter of priority
  WidgetsFlutterBinding.ensureInitialized();

  // Now we can create a consistent constructor asynchronously
  SettingsController controller =
      await SettingsController.consist(properties: settings);

  runApp(
    Settings(
      controller: controller,
      child: const SimpleApp(),
    ),
  );
}
```

#### Access to settings

Once the settings have been implemented, you can refer to them to get them or update the values.

To do this, you need to refer to the static function `of()`, which is available in the Settings class, and find the desired method to pass the property:

```dart
Settings.of(context).get(property);
```

Each time we need to send a new property to return or change the setting. Do you need to create a new property with similar settings every time when you make a change to the settings? Yes, but you don't have to do it yourself ever. In order to make a change, you need to use the `copyWith()` method, which is well known to Flutter developers. For example, look how simple it is:

```dart
Settings.of(context).update(property.copyWith(defaultValue: newValue));
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

1) `update(property)` - to update setting values both locally and for the current session;
2) `get(property)` - to get the setting value;
3) `setForSession(property)` - to set the value in the current session. This has no effect on saving the value in local storage, but causes listeners to be notified of the change in setting. This can be useful for changes only in the current session to a value that is stored locally, or for deferred saving to reduce the number of local storage accesses
4) `setForLocal(property)` - sets the value for local storage only. Changes will be synchronized only after restarting the application (in a new session)
5) `match()` - update (synchronization) of all the data of the current session with the data of the local storage. Relevant for making changes after calls to setForSession()
6) `getAll()` - returns Map() of all settings relevant for the current session

#### Helpers for access to settings

For convenience, the library implements helpers functions for accessing settings. These are available via `context` references and make it even easier to work with a simple `Settings()`. But it should be noted that these methods are not available for `MultiSettings()`. Because they do not allow you to access the locked settings.

Example:

```dart
context.getSetting(property);
```

Instead:

```dart
Settings.of(context).get(property);
```

Or:

```dart
context.listenSetting(property);
```

Instead:

```dart
Settings.of(context, listen = true).get(property);
```

Choose what is more convenient for you.

### MultiSettings()

The library also provides the ability to create separate groups of settings. They will have separate areas of responsibility, that is, they will have their own controller and notification system. Next, we will go through the steps that must be taken in order to use this option in your project:

1. Let's create separate configurations from properties:

First configuration:

```dart
const isDarkMode = Property<bool>(
  defaultValue: false,
  id: 'isDarkMode',
  isLocalStored: true,
);

const counterScaler = Property<int>(defaultValue: 1, id: 'counterScaler');

List<Property> firstSettingsConfig = [isDarkMode, counterScaler];
```

Second configuration:

```dart
const name = Property<String>(defaultValue: 'John', id: 'name');

List<Property> secondSettigsConfig = [name];
```

2. Let's create models for our property groups:

```dart
// A separate model for First screen settings
class FirstScreenSettings extends SettingsModel {
  FirstScreenSettings(super.controller);
}

// A separate model for Second screen settings
class SecondScreenSettings extends SettingsModel {
  SecondScreenSettings(super.controller);
}
```

3. Let's create separate controllers with their own properties:

```dart
SettingsController firstScreenController = await SettingsController.consist(properties: firstSettingsConfig);
  
SettingsController secondlScreenController = await SettingsController.consist(properties: secondSettigsConfig);
```

4. Let's implement settings through MultiSettings() and a special class for nested settings SettingsProvider():

```dart
runApp(
    // Instead of Settings, we use MultiSettings
    MultiSettings(
      providers: [
        SettingsProvider(model: FirstScreenSettings(firstScreenController)),
        SettingsProvider(
            model: SecondlScreenSettings(secondScreenController)),
      ],
      child: const App(),
    ),
  );
```

#### Access to settings in MultiSettings

```dart
Settings.of<FirstScreenSettings>(context).get(counterScaler);

Settings.of<SecondScreenSettings>(context).get(name);
```


## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
