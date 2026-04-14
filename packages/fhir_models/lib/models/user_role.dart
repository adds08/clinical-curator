/// Application-level role used for shell + nav selection.
///
/// Doctor vs nurse vs other practitioner sub-roles is *not* modelled here.
/// That distinction lives on `PractitionerRole.code` (the FHIR resource) and
/// is consumed by the RBAC layer to gate clinical actions.
enum UserRole {
  patient,
  clinician,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.clinician:
        return 'Clinician';
      case UserRole.admin:
        return 'Admin';
    }
  }

  bool get isPractitioner => this == clinician;
}
