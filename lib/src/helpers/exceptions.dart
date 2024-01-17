class NotUniqueIdExeption implements Exception {
  NotUniqueIdExeption(this.message, this.id);

  final String message;
  final String id;

  @override
  String toString() {
    return "NotUniqueIdExeption: $message. The following ID failed the uniqueness check: $id";
  }
}

class AdapterExeption implements Exception {
  AdapterExeption(this.message);

  final String message;

  @override
  String toString() {
    return "AdapterExeption: $message.";
  }
}

class InitializationError implements Exception {
  InitializationError({required this.model, this.message});

  final String model;
  final String? message;

  @override
  String toString() {
    return 'Error initializing settings model. Model: $model. $message';
  }
}
