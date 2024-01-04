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
