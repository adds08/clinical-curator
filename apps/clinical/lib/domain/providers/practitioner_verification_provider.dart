import 'package:cc_data/database/isar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Returns whether a practitioner is verified, looked up by FHIR practitioner ID.
/// Defaults to `true` if the account is not found (don't penalize missing data).
final practitionerVerifiedProvider =
    Provider.family<bool, String>((ref, practitionerRef) {
  final id = practitionerRef.replaceFirst('Practitioner/', '');
  final box = DatabaseService.userAccounts;
  for (final a in box.values) {
    if (a.fhirPractitionerId == id) {
      return a.isVerified;
    }
  }
  return true;
});
