import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/sync_service.dart';
import 'auth_provider.dart';
import 'connectivity_provider.dart';

/// Watches connectivity and triggers sync when the app goes online
/// and the user is authenticated.
final autoSyncProvider = Provider<void>((ref) {
  final isOnline = ref.watch(isOnlineProvider);
  final authState = ref.watch(authProvider);

  if (isOnline && authState.isAuthenticated) {
    // Trigger sync when we come online
    final syncState = ref.read(syncProvider);
    if (syncState.status != SyncStatus.syncing && syncState.pendingCount > 0) {
      ref.read(syncProvider.notifier).syncAll();
    }
  }
});
