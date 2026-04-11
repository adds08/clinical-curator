import 'package:clinical_curator_client/clinical_curator_client.dart' as api;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/auth/token_service.dart';
import '../../core/database/isar_service.dart';
import '../../data/collections/user_account_collection.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';
import 'serverpod_provider.dart';

class _AuthKeys {
  static const isLoggedIn = 'is_logged_in';
  static const userEmail = 'user_email';
  static const authMode = 'auth_mode'; // 'local' or 'server'
}

enum AuthMode { local, server }

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

  /// Login — tries Serverpod when online, falls back to local Hive.
  Future<void> login(String email, String password,
      {bool isOnline = false}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      if (isOnline && _serverpodClient != null) {
        final success = await _loginWithServer(email, password);
        if (success) return;
        // Server login failed — fall back to local
      }

      // Offline or server unavailable: local Hive lookup
      await _loginLocally(email, password);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed: ${e.toString()}',
      );
    }
  }

  /// Server-side login via Serverpod.
  Future<bool> _loginWithServer(String email, String password) async {
    try {
      final account = await _serverpodClient!.auth.login(email, password);
      if (account == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid email or password.',
        );
        return true; // handled — don't fall through
      }

      // Cache to local Hive for offline fallback
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
      return true;
    } catch (_) {
      // Server unreachable — return false to fall back to local
      return false;
    }
  }

  /// Cache server account in local Hive for offline login.
  Future<void> _cacheServerAccount(
      api.UserAccount serverAccount, String password) async {
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
        ..healthId = serverAccount.healthId
        ..passwordHash = password; // keep local password for offline
      await existing.save();
    } else {
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

  Future<void> signup(
    String email,
    String password,
    String displayName, {
    bool isOnline = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      if (isOnline && _serverpodClient != null) {
        try {
          final serverAccount = await _serverpodClient.auth.signup(
            email,
            password,
            displayName,
          );
          // Cache locally
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
          return;
        } catch (e) {
          // Server signup failed — show error, don't fall back to local
          state = state.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          );
          return;
        }
      }

      // Local signup
      final box = DatabaseService.userAccounts;
      final normalizedEmail = email.trim().toLowerCase();

      for (final a in box.values) {
        if (a.email == normalizedEmail) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'An account with that email already exists.',
          );
          return;
        }
      }

      final account = UserAccount()
        ..email = normalizedEmail
        ..passwordHash = password
        ..displayName = displayName.trim()
        ..isPractitioner = false
        ..isVerified = false
        ..accountType = 'patient'
        ..createdAt = DateTime.now();

      await box.add(account);

      final appUser = _mapAccountToUser(account);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_AuthKeys.isLoggedIn, true);
      await prefs.setString(_AuthKeys.userEmail, account.email);

      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        user: appUser,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Signup failed: ${e.toString()}',
      );
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
      role = account.practitionerType == 'nurse'
          ? UserRole.nurse
          : UserRole.doctor;
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

  AppUser _mapServerAccountToUser(api.UserAccount account) {
    UserRole role;
    if (account.accountType == 'admin') {
      role = UserRole.admin;
    } else if (account.isPractitioner) {
      role = account.practitionerType == 'nurse'
          ? UserRole.nurse
          : UserRole.doctor;
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
