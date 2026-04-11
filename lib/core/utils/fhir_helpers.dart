import 'dart:math';

import 'package:fhir/r4.dart';

class FhirHelpers {
  FhirHelpers._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Extracts a display name from a FHIR [Patient] resource.
  ///
  /// Tries the first [HumanName.text], then falls back to combining
  /// given + family names. Returns `'Unknown Patient'` when no name data
  /// is available.
  static String extractPatientName(Patient patient) {
    final names = patient.name;
    if (names == null || names.isEmpty) return 'Unknown Patient';

    final name = names.first;

    // Prefer the pre-composed text field
    if (name.text != null && name.text!.isNotEmpty) {
      return name.text!;
    }

    final given = name.given?.join(' ') ?? '';
    final family = name.family ?? '';
    final full = '$given $family'.trim();
    return full.isNotEmpty ? full : 'Unknown Patient';
  }

  /// Extracts a display name from a FHIR [Practitioner] resource.
  ///
  /// Uses the same strategy as [extractPatientName] but defaults to
  /// `'Unknown Practitioner'`.
  static String extractPractitionerName(Practitioner practitioner) {
    final names = practitioner.name;
    if (names == null || names.isEmpty) return 'Unknown Practitioner';

    final name = names.first;

    if (name.text != null && name.text!.isNotEmpty) {
      return name.text!;
    }

    final given = name.given?.join(' ') ?? '';
    final family = name.family ?? '';
    final full = '$given $family'.trim();
    return full.isNotEmpty ? full : 'Unknown Practitioner';
  }

  /// Extracts the value and unit from an [Observation]'s `valueQuantity`.
  ///
  /// Returns a formatted string like `"120 mmHg"`, or `null` when
  /// no quantity value is present.
  static String? extractObservationValue(Observation obs) {
    final quantity = obs.valueQuantity;
    if (quantity == null || quantity.value == null) return null;

    final value = quantity.value!.value;
    final unit = quantity.unit ?? '';
    return '$value $unit'.trim();
  }

  /// Formats a [FhirDate] as `'MMM dd, yyyy'` (e.g. "Mar 27, 2026").
  ///
  /// Returns `'Unknown date'` when the input is `null` or cannot be parsed.
  static String formatFhirDate(FhirDate? date) {
    if (date == null) return 'Unknown date';

    try {
      final dt = date.value;
      final month = _months[dt.month - 1];
      final day = dt.day.toString().padLeft(2, '0');
      return '$month $day, ${dt.year}';
    } catch (_) {
      return 'Unknown date';
    }
  }

  /// Generates a Nepal Health ID in the format `NEP-YYYY-XXXX-XX`.
  static String generateHealthId() {
    final random = Random();
    final year = DateTime.now().year;
    final mid = random.nextInt(10000).toString().padLeft(4, '0');
    final suffix = random.nextInt(100).toString().padLeft(2, '0');
    return 'NEP-$year-$mid-$suffix';
  }

  /// Generates a Patient ID in the format `PID-XXXXX`.
  static String generatePatientId() {
    final random = Random();
    final number = random.nextInt(100000).toString().padLeft(5, '0');
    return 'PID-$number';
  }
}
