class NotUniqueIdException implements Exception {
  NotUniqueIdException({required this.message, this.id});

  final String message;
  final String? id;

  @override
  String toString() {
    return id == null
        ? "NotUniqueIdException: $message"
        : "The following ID failed the uniqueness check: $id";
  }
}

class AdapterException implements Exception {
  AdapterException(this.message);

  final String message;

  @override
  String toString() {
    return "AdapterException: $message.";
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
