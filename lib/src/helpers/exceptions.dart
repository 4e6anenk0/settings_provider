class NotUniqueIdExeption implements Exception {
  NotUniqueIdExeption(this.message, this.id);

  final String message;
  final String id;

  @override
  String toString() {
    return "NotUniqueIdExeption: $message. The following ID failed the uniqueness check: $id";
  }
}

class ConfigBuilderExeption implements Exception {
  ConfigBuilderExeption(this.message);

  final String message;

  @override
  String toString() {
    return "ConfigBuilderExeption: $message.";
  }
}

class EmptyTargetConfigs implements Exception {
  EmptyTargetConfigs(this.message);

  final String message;

  @override
  String toString() {
    return "EmptyTargetConfigs: $message.";
  }
}
