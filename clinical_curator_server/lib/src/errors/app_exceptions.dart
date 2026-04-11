import 'package:serverpod/serverpod.dart';

/// Resource not found.
class NotFoundException extends SerializableException {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Validation failed (bad input).
class ValidationException extends SerializableException {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

/// Duplicate or conflicting resource.
class ConflictException extends SerializableException {
  final String message;
  ConflictException(this.message);

  @override
  String toString() => 'ConflictException: $message';
}

/// Unauthorized access.
class UnauthorizedException extends SerializableException {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}
