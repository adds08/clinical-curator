import 'package:clinical_curator_client/clinical_curator_client.dart' as api;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cc_core/auth/token_service.dart';
import 'package:cc_data/database/isar_service.dart';
import 'package:cc_fhir_models/collections/user_account_collection.dart';
import 'package:cc_fhir_models/models/app_user.dart';
import 'package:cc_fhir_models/models/user_role.dart';
import '../services/audit_logger.dart';
import 'serverpod_provider.dart';

class _AuthKeys {
  static const isLoggedIn = 'is_logged_in';
  static const userEmail = 'user_email';
  static const authMode = 'auth_mode'; // 'local' or 'server'
}

enum AuthMode { local, server }

enum _ServerLoginOutcome { ok, invalidCreds, unreachable }

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final AppUser? user;
  final String? errorMessage;
  final AuthMode authMode;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.authMode = AuthMode.local,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    AppUser? user,
    String? errorMessage,
    AuthMode? authMode,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      authMode: authMode ?? this.authMode,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenService _tokenService;
  final api.Client? _serverpodClient;

  AuthNotifier({TokenService? tokenService, api.Client? serverpodClient})
      : _tokenService = tokenService ?? TokenService(),
        _serverpodClient = serverpodClient,
        super(const AuthState());

  /// Login. Server is the source of truth — we always try Serverpod first.
  /// Hive is used only as an offline cache when the server is genuinely
  /// unreachable (network error), not as a silent fallback for invalid
  /// creds. The `isOnline` flag is ignored; kept for API compatibility.
  Future<void> login(String email, String password,
      {bool isOnline = true}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      if (_serverpodClient != null) {
        final outcome = await _loginWithServer(email, password);
        if (outcome == _ServerLoginOutcome.ok ||
            outcome == _ServerLoginOutcome.invalidCreds) {
          // Server spoke — don't second-guess with Hive.
          if (state.isAuthenticated) {
            await AuditLogger.loginSuccess(
                email: email, role: state.user?.practitionerType);
          } else {
            await AuditLogger.loginFailure(
                email: email, reason: state.errorMessage);
          }
          return;
        }
        // Server unreachable — fall through to Hive cache.
      }

      await _loginLocally(email, password);
      if (state.isAuthenticated) {
        await AuditLogger.loginSuccess(
            email: email, role: state.user?.practitionerType);
      } else {
        await AuditLogger.loginFailure(
            email: email, reason: state.errorMessage);
      }
    } catch (e) {
      await AuditLogger.loginFailure(email: email, reason: e.toString());
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed: ${e.toString()}',
      );
    }
  }

  /// Server-side login via Serverpod.
  Future<_ServerLoginOutcome> _loginWithServer(
      String email, String password) async {
    try {
      var account = await _serverpodClient!.auth.login(email, password);

      // Migration path: the user may exist in local Hive from a previous
      // offline-only signup, but not yet on the server. If creds match the
      // cached row, auto-promote them to the server (signup) + re-register
      // practitioner status so the admin queue picks them up. This lets
      // existing local accounts recover without the user having to re-signup.
      if (account == null) {
        final migrated = await _migrateLocalAccountToServer(email, password);
        if (migrated != null) {
          account = migrated;
        } else {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'Invalid email or password.',
          );
          return _ServerLoginOutcome.invalidCreds;
        }
      }

      await _cacheServerAccount(account, password);
      final appUser = _mapServerAccountToUser(account);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_AuthKeys.isLoggedIn, true);
      await prefs.setString(_AuthKeys.userEmail, account.email);
      await prefs.setString(_AuthKeys.authMode, AuthMode.server.name);

      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: appUser,
        authMode: AuthMode.server,
      );
      return _ServerLoginOutcome.ok;
    } catch (_) {
      return _ServerLoginOutcome.unreachable;
    }
  }

  /// Cache server account in local Hive for offline login.
  Future<void> _cacheServerAccount(
      api.UserAccount serverAccount, String? password) async {
    final box = DatabaseService.userAccounts;
    final normalizedEmail = serverAccount.email.trim().toLowerCase();

    // Update existing or add new
    UserAccount? existing;
    for (final a in box.values) {
      if (a.email == normalizedEmail) {
        existing = a;
        break;
      }
    }

    if (existing != null) {
      existing
        ..displayName = serverAccount.displayName
        ..isPractitioner = serverAccount.isPractitioner
        ..isVerified = serverAccount.isVerified
        ..practitionerType = serverAccount.practitionerType
        ..accountType = serverAccount.accountType
        ..fhirPatientId = serverAccount.fhirPatientId
        ..fhirPractitionerId = serverAccount.fhirPractitionerId
        ..healthId = serverAccount.healthId;
      if (password != null) {
        existing.passwordHash = password;
      }
      await existing.save();
    } else if (password != null) {
      final local = UserAccount()
        ..email = normalizedEmail
        ..passwordHash = password
        ..displayName = serverAccount.displayName
        ..isPractitioner = serverAccount.isPractitioner
        ..isVerified = serverAccount.isVerified
        ..practitionerType = serverAccount.practitionerType
        ..accountType = serverAccount.accountType
        ..fhirPatientId = serverAccount.fhirPatientId
        ..fhirPractitionerId = serverAccount.fhirPractitionerId
        ..healthId = serverAccount.healthId
        ..createdAt = DateTime.now();
      await box.add(local);
    }
  }

  /// Local Hive-based login (offline fallback).
  Future<bool> _loginLocally(String email, String password,
      {AuthMode authMode = AuthMode.local}) async {
    final box = DatabaseService.userAccounts;
    final normalizedEmail = email.trim().toLowerCase();

    UserAccount? account;
    for (final a in box.values) {
      if (a.email == normalizedEmail) {
        account = a;
        break;
      }
    }

    if (account == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No account found with that email.',
      );
      return false;
    }

    if (account.passwordHash != password) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid password.',
      );
      return false;
    }

    final appUser = _mapAccountToUser(account);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_AuthKeys.isLoggedIn, true);
    await prefs.setString(_AuthKeys.userEmail, account.email);
    await prefs.setString(_AuthKeys.authMode, authMode.name);

    state = AuthState(
      isAuthenticated: true,
      isLoading: false,
      user: appUser,
      authMode: authMode,
    );
    return true;
  }

  /// Signup. Always writes to Serverpod — the backend is the source of
  /// truth for user identity. Without a server-side row, the admin app
  /// cannot see this user in the verification queue. If the server is
  /// unreachable we surface the error rather than silently creating a
  /// local-only ghost account. The `isOnline` flag is ignored; kept for
  /// API compatibility.
  Future<void> signup(
    String email,
    String password,
    String displayName, {
    bool isOnline = true,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    if (_serverpodClient == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Cannot sign up: server client not available.',
      );
      return;
    }

    try {
      final serverAccount = await _serverpodClient.auth.signup(
        email,
        password,
        displayName,
      );
      await _cacheServerAccount(serverAccount, password);

      final appUser = _mapServerAccountToUser(serverAccount);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_AuthKeys.isLoggedIn, true);
      await prefs.setString(_AuthKeys.userEmail, serverAccount.email);
      await prefs.setString(_AuthKeys.authMode, AuthMode.server.name);

      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: appUser,
        authMode: AuthMode.server,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Signup failed: ${e.toString()}',
      );
    }
  }

  /// Submit a practitioner registration to the server. Looks up the
  /// server-side UserAccount by email, calls `auth.registerPractitioner`
  /// so the admin app's pending queue sees the new application.
  /// Returns true on success, false with `errorMessage` populated on failure.
  Future<bool> submitPractitionerRegistration({
    required String practitionerType,
    required String licenseNumber,
    required String specialization,
  }) async {
    final current = state.user;
    if (current == null) {
      state = state.copyWith(errorMessage: 'Not logged in.');
      return false;
    }
    if (_serverpodClient == null) {
      state = state.copyWith(
          errorMessage: 'Server unavailable — cannot submit registration.');
      return false;
    }
    try {
      final serverAccount =
          await _serverpodClient.auth.getByEmail(current.email);
      if (serverAccount == null || serverAccount.id == null) {
        state = state.copyWith(
          errorMessage:
              'Your account is not on the server yet. Please sign out and sign up again while online.',
        );
        return false;
      }
      final updated = await _serverpodClient.auth.registerPractitioner(
        serverAccount.id!,
        practitionerType,
        licenseNumber,
        specialization,
      );
      await _cacheServerAccount(updated, null);
      state = state.copyWith(user: _mapServerAccountToUser(updated));
      return true;
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Registration failed: ${e.toString()}');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_AuthKeys.isLoggedIn);
    await prefs.remove(_AuthKeys.userEmail);
    await prefs.remove(_AuthKeys.authMode);
    await _tokenService.clearTokens();
    state = const AuthState();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_AuthKeys.isLoggedIn) ?? false;

      if (!isLoggedIn) {
        state = const AuthState();
        return;
      }

      final savedEmail = prefs.getString(_AuthKeys.userEmail);
      if (savedEmail == null) {
        state = const AuthState();
        return;
      }

      // Check if we have a valid JWT token
      final hasTokens = await _tokenService.hasTokens();
      final tokenExpired = await _tokenService.isTokenExpired();

      AuthMode mode = AuthMode.local;
      final savedMode = prefs.getString(_AuthKeys.authMode);
      if (savedMode == 'server' && hasTokens && !tokenExpired) {
        mode = AuthMode.server;
      }

      final box = DatabaseService.userAccounts;
      UserAccount? account;
      for (final a in box.values) {
        if (a.email == savedEmail) {
          account = a;
          break;
        }
      }

      if (account == null) {
        await prefs.remove(_AuthKeys.isLoggedIn);
        await prefs.remove(_AuthKeys.userEmail);
        state = const AuthState();
        return;
      }

      final appUser = _mapAccountToUser(account);
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: appUser,
        authMode: mode,
      );
    } catch (e) {
      state = const AuthState();
    }
  }

  AppUser _mapAccountToUser(UserAccount account) {
    UserRole role;
    if (account.accountType == 'admin') {
      role = UserRole.admin;
    } else if (account.isPractitioner) {
      // Doctor vs nurse distinction lives on practitionerType (FHIR
      // PractitionerRole.code) — UserRole only carries shell-level identity.
      role = UserRole.clinician;
    } else {
      role = UserRole.patient;
    }

    return AppUser(
      id: account.key.toString(),
      email: account.email,
      displayName: account.displayName,
      fhirPatientId: account.fhirPatientId,
      fhirPractitionerId: account.fhirPractitionerId,
      isPractitioner: account.isPractitioner,
      isVerified: account.isVerified,
      practitionerType: account.practitionerType,
      activeRole: role,
      avatarUrl: account.avatarUrl,
      healthId: account.healthId,
    );
  }

  /// Promote a Hive-only account to Serverpod on first login post-migration.
  /// Only runs when: (a) server says creds are invalid, AND (b) local Hive
  /// has a row with matching email+password. Mirrors the local practitioner
  /// flags to the server so admin's verification queue picks them up.
  /// Returns the new server account, or null if migration doesn't apply.
  Future<api.UserAccount?> _migrateLocalAccountToServer(
      String email, String password) async {
    if (_serverpodClient == null) return null;
    try {
      final box = DatabaseService.userAccounts;
      final normalized = email.trim().toLowerCase();
      UserAccount? local;
      for (final a in box.values) {
        if (a.email == normalized) {
          local = a;
          break;
        }
      }
      if (local == null) return null;
      if (local.passwordHash != password) return null;

      final created = await _serverpodClient.auth.signup(
        normalized,
        password,
        local.displayName,
      );
      if (created.id == null) return created;

      if (local.isPractitioner) {
        final promoted = await _serverpodClient.auth.registerPractitioner(
          created.id!,
          local.practitionerType ?? 'doctor',
          '',
          '',
        );
        return promoted;
      }
      return created;
    } catch (_) {
      return null;
    }
  }

  AppUser _mapServerAccountToUser(api.UserAccount account) {
    UserRole role;
    if (account.accountType == 'admin') {
      role = UserRole.admin;
    } else if (account.isPractitioner) {
      role = UserRole.clinician;
    } else {
      role = UserRole.patient;
    }

    return AppUser(
      id: account.id.toString(),
      email: account.email,
      displayName: account.displayName,
      fhirPatientId: account.fhirPatientId,
      fhirPractitionerId: account.fhirPractitionerId,
      isPractitioner: account.isPractitioner,
      isVerified: account.isVerified,
      practitionerType: account.practitionerType,
      activeRole: role,
      healthId: account.healthId,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final client = ref.watch(serverpodClientProvider);
  return AuthNotifier(serverpodClient: client);
});
