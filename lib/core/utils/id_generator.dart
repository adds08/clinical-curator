import 'dart:math';

class IdGenerator {
  IdGenerator._();

  static final _random = Random();

  /// Generates a Nepal Health ID in the format `NEP-YYYY-XXXX-XX`.
  ///
  /// Example: `NEP-2026-4821-07`
  static String generateHealthId() {
    final year = DateTime.now().year;
    final mid = _random.nextInt(10000).toString().padLeft(4, '0');
    final suffix = _random.nextInt(100).toString().padLeft(2, '0');
    return 'NEP-$year-$mid-$suffix';
  }

  /// Generates a Patient ID in the format `PID-XXXXX`.
  ///
  /// Example: `PID-03817`
  static String generatePatientId() {
    final number = _random.nextInt(100000).toString().padLeft(5, '0');
    return 'PID-$number';
  }

  /// Generates a Registration ID in the format `REG-YYYY-XXXX-X`.
  ///
  /// Example: `REG-2026-7294-3`
  static String generateRegistrationId() {
    final year = DateTime.now().year;
    final mid = _random.nextInt(10000).toString().padLeft(4, '0');
    final suffix = _random.nextInt(10).toString();
    return 'REG-$year-$mid-$suffix';
  }
}
