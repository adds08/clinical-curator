import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../domain/services/fhir_sync_service.dart';

/// Tiny status chip shown in the clinical app AppBar. Displays either:
///   - "Offline" with a wifiOff icon when connectivity is down
///   - "Syncing…" while a round-trip is in flight
///   - "Synced Xm ago" with a refreshCw icon on success
///
/// Tap opens a shadcn Popover with per-resource counts from the last
/// [SyncReport] and a "Sync now" primary button.
class SyncChip extends ConsumerWidget {
  const SyncChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fhirSyncServiceProvider);
    final notifier = ref.read(fhirSyncServiceProvider.notifier);
    final colors = Theme.of(context).colorScheme;

    final IconData icon;
    final String label;
    if (!state.isOnline) {
      icon = LucideIcons.wifiOff;
      label = 'Offline';
    } else if (state.isSyncing) {
      icon = LucideIcons.refreshCw;
      label = 'Syncing…';
    } else if (state.lastReport == null) {
      icon = LucideIcons.refreshCw;
      label = 'Sync';
    } else {
      icon = LucideIcons.refreshCw;
      label = 'Synced ${_ago(state.lastReport!.completedAt)}';
    }

    return GestureDetector(
      onTap: () => _openPopover(context, state.lastReport, notifier),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.muted,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 13,
                color: state.isOnline
                    ? colors.mutedForeground
                    : colors.destructive),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: colors.foreground)),
          ],
        ),
      ),
    );
  }

  void _openPopover(
    BuildContext context,
    SyncReport? report,
    FhirSyncService svc,
  ) {
    final colors = Theme.of(context).colorScheme;
    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sync status',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground)),
            const SizedBox(height: 4),
            Text(
              report == null
                  ? 'No sync has run yet.'
                  : report.skippedOffline
                      ? 'Skipped — device is offline.'
                      : 'Completed ${_ago(report.completedAt)} · ${report.elapsed.inMilliseconds} ms',
              style: TextStyle(fontSize: 12, color: colors.mutedForeground),
            ),
            const SizedBox(height: 20),
            if (report != null && report.perType.isNotEmpty) ...[
              for (final entry in report.perType.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(entry.key,
                              style: TextStyle(
                                  fontSize: 13, color: colors.foreground))),
                      Text('+${entry.value}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.primary)),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Divider(height: 1, color: colors.border),
              const SizedBox(height: 8),
            ],
            if (report != null) ...[
              _kv(colors, 'Upserted', '${report.upserted}'),
              _kv(colors, 'Pushed', '${report.pushed}'),
              _kv(colors, 'Conflicts', '${report.conflicts}'),
              if (report.errorMessage != null)
                _kv(colors, 'Error', report.errorMessage!),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Button.primary(
                onPressed: () async {
                  closeDrawer(ctx);
                  await svc.syncAll();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.refreshCw, size: 16),
                    SizedBox(width: 6),
                    Text('Sync now'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(ColorScheme c, String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Expanded(
                child: Text(k,
                    style:
                        TextStyle(fontSize: 12, color: c.mutedForeground))),
            Text(v,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: c.foreground)),
          ],
        ),
      );

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inSeconds < 60) return '${d.inSeconds}s ago';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}
