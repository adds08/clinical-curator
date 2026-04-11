import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/audit_event_collection.dart';
import '../../shared/widgets/sub_page_scaffold.dart';

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  String _actionFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final box = DatabaseService.auditEvents;
    var events = box.values.toList()
      ..sort((a, b) => b.recorded.compareTo(a.recorded));

    if (_actionFilter != 'all') {
      events = events.where((e) => e.action == _actionFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      events = events
          .where((e) =>
              e.agentName.toLowerCase().contains(q) ||
              (e.detail?.toLowerCase().contains(q) ?? false) ||
              (e.entityType?.toLowerCase().contains(q) ?? false))
          .toList();
    }

    return SubPageScaffold(
      title: 'Audit Log',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextArea(
                    initialValue: _searchQuery,
                    placeholder: const Text('Search events...'),
                    onChanged: (v) => setState(() => _searchQuery = v),
                    expandableWidth: false,
                    minLines: 1,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final filter in [
                        'all',
                        'login',
                        'logout',
                        'create',
                        'read',
                        'update',
                        'delete'
                      ])
                        Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.sm),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _actionFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                color: _actionFilter == filter
                                    ? colors.primary
                                    : colors.surfaceLow,
                                borderRadius: AppRadius.chipRadius,
                              ),
                              child: Text(
                                filter[0].toUpperCase() +
                                    filter.substring(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _actionFilter == filter
                                      ? colors.primaryForeground
                                      : colors.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                Text(
                  '${events.length} events',
                  style: TextStyle(
                      fontSize: 12, color: colors.mutedForeground),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text('No audit events',
                        style: TextStyle(color: colors.mutedForeground)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl),
                    itemCount: events.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) =>
                        _AuditEventRow(event: events[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AuditEventRow extends StatelessWidget {
  final AuditEventLocal event;
  const _AuditEventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('MMM d, HH:mm');

    final actionColor = switch (event.action) {
      'create' => colors.success,
      'delete' => colors.destructive,
      'login' || 'logout' => colors.primary,
      'update' => colors.warning,
      _ => colors.mutedForeground,
    };

    final actionIcon = switch (event.action) {
      'login' => Icons.login_rounded,
      'logout' => Icons.logout_rounded,
      'create' => Icons.add_circle_outline_rounded,
      'update' => Icons.edit_outlined,
      'delete' => Icons.delete_outline_rounded,
      'read' => Icons.visibility_outlined,
      _ => Icons.info_outline_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: SurfaceTheme.cardDecoration(context: context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(actionIcon, size: 16, color: actionColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.agentName,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.foreground),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: actionColor.withValues(alpha: 0.12),
                        borderRadius: AppRadius.chipRadius,
                      ),
                      child: Text(
                        event.action,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: actionColor),
                      ),
                    ),
                  ],
                ),
                if (event.detail != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    event.detail!,
                    style: TextStyle(
                        fontSize: 12, color: colors.mutedForeground),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (event.entityType != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${event.entityType} · ${event.entityRef ?? "—"}',
                    style: TextStyle(
                        fontSize: 11, color: colors.mutedForeground),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateFormat.format(event.recorded),
                style: TextStyle(
                    fontSize: 11, color: colors.mutedForeground),
              ),
              const SizedBox(height: 2),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: event.outcome == 'success'
                      ? colors.success
                      : colors.destructive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
