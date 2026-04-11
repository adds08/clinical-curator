class Validators {
  Validators._();

  /// Validates an email address.
  ///
  /// Returns an error message when the value is empty or does not match
  /// a basic email pattern, `null` otherwise.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a password.
  ///
  /// Must be at least 8 characters long and contain at least one digit.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least 1 number';
    }
    return null;
  }

  /// Validates a name field.
  ///
  /// Must be non-empty and at least 2 characters.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates a Nepal phone number.
  ///
  /// Must be exactly 10 digits and start with `9`.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!digits.startsWith('9')) {
      return 'Phone number must start with 9';
    }
    return null;
  }

  /// Validates a practitioner license number.
  ///
  /// Must be non-empty and alphanumeric.
  static String? validateLicenseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'License number is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value.trim())) {
      return 'License number must be alphanumeric';
    }
    return null;
  }
}
