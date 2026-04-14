import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/domain/providers/auth_provider.dart';

void main() {
  group('AuthState', () {
    test('has correct defaults', () {
      const state = AuthState();
      expect(state.isAuthenticated, false);
      expect(state.isLoading, false);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates specified fields', () {
      const state = AuthState();
      final updated = state.copyWith(isLoading: true);
      expect(updated.isLoading, true);
      expect(updated.isAuthenticated, false);
    });

    test('copyWith preserves unspecified fields', () {
      const state = AuthState(isAuthenticated: true, isLoading: true);
      final updated = state.copyWith(isLoading: false);
      expect(updated.isAuthenticated, true);
      expect(updated.isLoading, false);
    });

    test('copyWith clearUser nulls user', () {
      const state = AuthState();
      final updated = state.copyWith(clearUser: true);
      expect(updated.user, isNull);
    });

    test('copyWith clearError nulls error', () {
      const state = AuthState(errorMessage: 'error');
      final updated = state.copyWith(clearError: true);
      expect(updated.errorMessage, isNull);
    });

    test('copyWith with errorMessage sets it', () {
      const state = AuthState();
      final updated = state.copyWith(errorMessage: 'Login failed');
      expect(updated.errorMessage, 'Login failed');
    });
  });
}
