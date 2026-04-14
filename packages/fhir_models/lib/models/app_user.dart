import 'package:equatable/equatable.dart';

import 'user_role.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? fhirPatientId;
  final String? fhirPractitionerId;
  final bool isPractitioner;
  final bool isVerified;
  final String? practitionerType;
  final UserRole activeRole;
  final String? avatarUrl;
  final String? healthId;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.fhirPatientId,
    this.fhirPractitionerId,
    this.isPractitioner = false,
    this.isVerified = false,
    this.practitionerType,
    this.activeRole = UserRole.patient,
    this.avatarUrl,
    this.healthId,
  });

  /// Whether this user can toggle between patient and practitioner roles.
  /// Only verified practitioners are allowed to switch roles.
  bool get canToggleRole => isPractitioner && isVerified;

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? fhirPatientId,
    String? fhirPractitionerId,
    bool? isPractitioner,
    bool? isVerified,
    String? practitionerType,
    UserRole? activeRole,
    String? avatarUrl,
    String? healthId,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      fhirPatientId: fhirPatientId ?? this.fhirPatientId,
      fhirPractitionerId: fhirPractitionerId ?? this.fhirPractitionerId,
      isPractitioner: isPractitioner ?? this.isPractitioner,
      isVerified: isVerified ?? this.isVerified,
      practitionerType: practitionerType ?? this.practitionerType,
      activeRole: activeRole ?? this.activeRole,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      healthId: healthId ?? this.healthId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        fhirPatientId,
        fhirPractitionerId,
        isPractitioner,
        isVerified,
        practitionerType,
        activeRole,
        avatarUrl,
        healthId,
      ];
}
