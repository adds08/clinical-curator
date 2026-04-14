import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cc_fhir_models/models/user_role.dart';

const _roleKey = 'active_user_role';

/// StateNotifier that manages the active user role and persists it with
/// SharedPreferences.
class RoleNotifier extends StateNotifier<UserRole> {
  RoleNotifier() : super(UserRole.patient);

  /// Read the previously saved role from SharedPreferences.
  Future<void> loadSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString(_roleKey);

    if (savedRole != null) {
      try {
        state = UserRole.values.firstWhere(
          (r) => r.name == savedRole,
          orElse: () {
            // Migrate legacy persisted values from the pre-cutover enum.
            if (savedRole == 'doctor' || savedRole == 'nurse') {
              return UserRole.clinician;
            }
            return UserRole.patient;
          },
        );
      } catch (_) {
        state = UserRole.patient;
      }
    }
  }

  /// Set the active role and persist it.
  Future<void> setRole(UserRole role) async {
    state = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.name);
  }

  /// Toggle between patient and clinician roles. Practitioner sub-role
  /// (doctor vs nurse) is unrelated and lives on PractitionerRole.code.
  void toggleRole() {
    if (state == UserRole.patient) {
      setRole(UserRole.clinician);
    } else {
      setRole(UserRole.patient);
    }
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, UserRole>((ref) {
  return RoleNotifier();
});
