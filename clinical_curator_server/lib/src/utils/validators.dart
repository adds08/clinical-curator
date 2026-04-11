import '../errors/app_exceptions.dart';

class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validate email format and length.
  static void validateEmail(String email) {
    if (email.trim().isEmpty) {
      throw ValidationException('Email is required.');
    }
    if (email.length > 254) {
      throw ValidationException('Email exceeds maximum length.');
    }
    if (!_emailRegex.hasMatch(email.trim().toLowerCase())) {
      throw ValidationException('Invalid email format.');
    }
  }

  /// Validate password strength (min 8 chars).
  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw ValidationException('Password is required.');
    }
    if (password.length < 8) {
      throw ValidationException('Password must be at least 8 characters.');
    }
    if (password.length > 128) {
      throw ValidationException('Password exceeds maximum length.');
    }
  }

  /// Validate string length.
  static void validateStringLength(
    String input,
    String fieldName, {
    int maxLength = 255,
    int minLength = 1,
  }) {
    if (input.trim().length < minLength) {
      throw ValidationException('$fieldName is required.');
    }
    if (input.length > maxLength) {
      throw ValidationException(
        '$fieldName exceeds maximum length of $maxLength characters.',
      );
    }
  }

  /// Sanitize a search query (strip SQL wildcards).
  static String sanitizeSearchQuery(String query, {int maxLength = 100}) {
    if (query.length > maxLength) {
      query = query.substring(0, maxLength);
    }
    return query.replaceAll(RegExp(r'[%_\\]'), '');
  }
}
