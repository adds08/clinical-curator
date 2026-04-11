import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_role.dart';

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
          orElse: () => UserRole.patient,
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

  /// Toggle between patient and doctor/nurse roles.
  /// If the current role is patient, switch to doctor.
  /// If the current role is doctor or nurse, switch to patient.
  void toggleRole() {
    if (state == UserRole.patient) {
      setRole(UserRole.doctor);
    } else {
      setRole(UserRole.patient);
    }
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, UserRole>((ref) {
  return RoleNotifier();
});
