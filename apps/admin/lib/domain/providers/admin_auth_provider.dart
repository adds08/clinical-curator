import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'serverpod_provider.dart';

/// Admin-only auth. Authenticates against the Serverpod backend and
/// rejects any account whose `accountType != 'admin'`. Serverpod is the
/// single source of truth — admin no longer consults any local cache.
///
/// Seed admin credentials: `admin@example.com` / `admin123`.
class _Keys {
  static const isLoggedIn = 'admin_is_logged_in';
  static const email = 'admin_email';
}

class AdminAuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? email;
  final String? displayName;
  final String? errorMessage;

  const AdminAuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.email,
    this.displayName,
    this.errorMessage,
  });

  AdminAuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? email,
    String? displayName,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AdminAuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AdminAuthNotifier extends StateNotifier<AdminAuthState> {
  AdminAuthNotifier(this._ref) : super(const AdminAuthState());

  final Ref _ref;

  Client get _client => _ref.read(serverpodClientProvider);

  /// Re-hydrate a previous admin session from SharedPreferences, then
  /// verify against the server that the account still exists and is
  /// still an admin. If the server is unreachable we clear the session
  /// rather than trust stale creds.
  Future<void> restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loggedIn = prefs.getBool(_Keys.isLoggedIn) ?? false;
      final email = prefs.getString(_Keys.email);
      if (!loggedIn || email == null) return;

      final account = await _client.auth.getByEmail(email);
      if (account == null || account.accountType != 'admin') {
        await prefs.remove(_Keys.isLoggedIn);
        await prefs.remove(_Keys.email);
        return;
      }
      state = AdminAuthState(
        isAuthenticated: true,
        email: account.email,
        displayName: account.displayName,
      );
    } catch (_) {
      // Network / server error — leave user on login screen.
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final normalized = email.trim().toLowerCase();
      final account = await _client.auth.login(normalized, password);

      if (account == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid email or password.',
        );
        return;
      }
      if (account.accountType != 'admin') {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'This account is not authorized for admin access.',
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_Keys.isLoggedIn, true);
      await prefs.setString(_Keys.email, account.email);

      state = AdminAuthState(
        isAuthenticated: true,
        isLoading: false,
        email: account.email,
        displayName: account.displayName,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed: $e',
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_Keys.isLoggedIn);
    await prefs.remove(_Keys.email);
    state = const AdminAuthState();
  }
}

final adminAuthProvider =
    StateNotifierProvider<AdminAuthNotifier, AdminAuthState>(
  (ref) => AdminAuthNotifier(ref),
);
