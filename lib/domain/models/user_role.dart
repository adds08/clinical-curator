enum UserRole {
  patient,
  doctor,
  nurse,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.nurse:
        return 'Nurse';
      case UserRole.admin:
        return 'Admin';
    }
  }

  bool get isPractitioner => this == doctor || this == nurse;
}
