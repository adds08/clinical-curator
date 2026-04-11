import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/domain/models/app_user.dart';
import 'package:clinical_curator/domain/models/user_role.dart';

void main() {
  group('AppUser', () {
    const user = AppUser(
      id: '1',
      email: 'arjun@test.com',
      displayName: 'Arjun Sharma',
      fhirPatientId: 'patient-arjun',
      isPractitioner: false,
      isVerified: false,
      activeRole: UserRole.patient,
    );

    test('creates with required fields', () {
      expect(user.id, '1');
      expect(user.email, 'arjun@test.com');
      expect(user.displayName, 'Arjun Sharma');
    });

    test('defaults to patient role', () {
      const minUser = AppUser(
        id: '1',
        email: 'test@test.com',
        displayName: 'Test',
      );
      expect(minUser.activeRole, UserRole.patient);
      expect(minUser.isPractitioner, false);
      expect(minUser.isVerified, false);
    });

    test('canToggleRole is false for non-practitioners', () {
      expect(user.canToggleRole, false);
    });

    test('canToggleRole is false for unverified practitioners', () {
      const unverified = AppUser(
        id: '2',
        email: 'doc@test.com',
        displayName: 'Dr. Smith',
        isPractitioner: true,
        isVerified: false,
        activeRole: UserRole.doctor,
      );
      expect(unverified.canToggleRole, false);
    });

    test('canToggleRole is true for verified practitioners', () {
      const verified = AppUser(
        id: '3',
        email: 'doc@test.com',
        displayName: 'Dr. Priya',
        isPractitioner: true,
        isVerified: true,
        activeRole: UserRole.doctor,
      );
      expect(verified.canToggleRole, true);
    });

    test('copyWith returns new instance with updated fields', () {
      final updated = user.copyWith(displayName: 'Arjun K. Sharma');
      expect(updated.displayName, 'Arjun K. Sharma');
      expect(updated.id, user.id);
      expect(updated.email, user.email);
    });

    test('copyWith can change role', () {
      final updated = user.copyWith(
        activeRole: UserRole.doctor,
        isPractitioner: true,
        isVerified: true,
      );
      expect(updated.activeRole, UserRole.doctor);
      expect(updated.canToggleRole, true);
    });

    test('equatable compares by value', () {
      const same = AppUser(
        id: '1',
        email: 'arjun@test.com',
        displayName: 'Arjun Sharma',
        fhirPatientId: 'patient-arjun',
        isPractitioner: false,
        isVerified: false,
        activeRole: UserRole.patient,
      );
      expect(user, equals(same));
    });

    test('equatable detects differences', () {
      final different = user.copyWith(email: 'other@test.com');
      expect(user, isNot(equals(different)));
    });
  });

  group('UserRole', () {
    test('displayName returns correct strings', () {
      expect(UserRole.patient.displayName, 'Patient');
      expect(UserRole.doctor.displayName, 'Doctor');
      expect(UserRole.nurse.displayName, 'Nurse');
      expect(UserRole.admin.displayName, 'Admin');
    });

    test('isPractitioner is correct', () {
      expect(UserRole.patient.isPractitioner, false);
      expect(UserRole.doctor.isPractitioner, true);
      expect(UserRole.nurse.isPractitioner, true);
      expect(UserRole.admin.isPractitioner, false);
    });
  });
}
