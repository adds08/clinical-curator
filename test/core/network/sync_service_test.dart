import 'package:flutter_test/flutter_test.dart';
import 'package:clinical_curator/core/network/sync_service.dart';

void main() {
  group('SyncState', () {
    test('has correct defaults', () {
      const state = SyncState();
      expect(state.status, SyncStatus.idle);
      expect(state.pendingCount, 0);
      expect(state.errorMessage, isNull);
      expect(state.lastSyncAt, isNull);
    });

    test('copyWith updates status', () {
      const state = SyncState();
      final updated = state.copyWith(status: SyncStatus.syncing);
      expect(updated.status, SyncStatus.syncing);
      expect(updated.pendingCount, 0);
    });

    test('copyWith updates pendingCount', () {
      const state = SyncState();
      final updated = state.copyWith(pendingCount: 5);
      expect(updated.pendingCount, 5);
    });

    test('copyWith clearError nulls message', () {
      const state = SyncState(errorMessage: 'fail');
      final updated = state.copyWith(clearError: true);
      expect(updated.errorMessage, isNull);
    });

    test('copyWith preserves unspecified fields', () {
      final now = DateTime.now();
      final state = SyncState(
        status: SyncStatus.success,
        pendingCount: 3,
        lastSyncAt: now,
      );
      final updated = state.copyWith(pendingCount: 0);
      expect(updated.status, SyncStatus.success);
      expect(updated.lastSyncAt, now);
      expect(updated.pendingCount, 0);
    });
  });

  group('SyncStatus', () {
    test('has all expected values', () {
      expect(SyncStatus.values, containsAll([
        SyncStatus.idle,
        SyncStatus.syncing,
        SyncStatus.success,
        SyncStatus.error,
      ]));
    });
  });
}
