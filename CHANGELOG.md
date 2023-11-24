## 0.0.1

* Init project structure
* Implemented some base fuction

## 0.0.2

* The implemented system of implementing settings in the widget tree is similar to the provider, but simpler;
* Some interfaces have been created: for building repositories and controllers;
* Implemented work with Shared Preferences separately from the controller;
* Created a separate type of settings and additional classes to build a dependent UI from Enum.

## 0.1.0

* first release on pub.dev

## 0.1.1

* some fixes in docs and code

## 0.2.0

* Added new feature for creating configurations depending on the platform;
* Improved interface of context extensions;
* Generalized interface for configurations and settings separately;
* Some improvements.

## 0.2.1

* Changes for standardizing access to settings. Now, `BuildContext()` extensions have limited options for accessing settings. The available context methods include `setting<T>()` and `listenSetting<T>()`. Additionally, the `of()` method has been deprecated in favor of two separate methods, `from()` and `listenFrom()`.
* Now, to create settings, it is mandatory to create a class based on `SettingsModel()` for settings or a class based on `ConfigModel()` for configs. The type of this class must be specified when accessing settings through context methods.
* Thanks to standardization, `ScenarioBuilder()` can now be used in both configs and regular settings.

## 0.2.2

* A bug with local saving of Scenario properties has been fixed.
