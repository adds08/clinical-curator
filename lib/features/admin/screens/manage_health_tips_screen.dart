import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../core/theme/clinical_colors.dart';
import '../../../data/collections/health_tip_collection.dart';
import '../../../domain/providers/health_tip_provider.dart';

class ManageHealthTipsScreen extends ConsumerWidget {
  const ManageHealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final allTips = ref.watch(allHealthTipsProvider);
    final activeCount = allTips.where((t) => t.isActive).length;

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Tips',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: colors.foreground,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 2),
                      Text(
                          '$activeCount active of ${allTips.length} total',
                          style: TextStyle(
                              fontSize: 12,
                              color: colors.mutedForeground)),
                    ],
                  ),
                  Button.primary(
                    onPressed: () => _openTipDrawer(context, ref, null),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16),
                        SizedBox(width: 4),
                        Text('New Tip',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              if (allTips.isEmpty)
                Card(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  fillColor:
                      SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                  borderRadius: AppRadius.cardRadius,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            size: 36,
                            color: colors.mutedForeground
                                .withValues(alpha: 0.4)),
                        const SizedBox(height: AppSpacing.md),
                        Text('No health tips yet',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.mutedForeground)),
                      ],
                    ),
                  ),
                )
              else
                ...allTips.map((tip) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _buildTipCard(context, ref, tip),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(
      BuildContext context, WidgetRef ref, HealthTipLocal tip) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      padding: const EdgeInsets.all(AppSpacing.lg),
      fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
      borderRadius: AppRadius.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(tip.title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.foreground)),
              ),
              tip.isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: colors.successBackground,
                          borderRadius: AppRadius.chipRadius),
                      child: Text('ACTIVE',
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colors.success,
                              letterSpacing: 0.5)),
                    )
                  : const SecondaryBadge(child: Text('DRAFT')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(tip.summary,
              style: TextStyle(
                  fontSize: 12,
                  color: colors.mutedForeground,
                  height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: SurfaceTheme.colorFor(SurfaceLevel.low, context),
              borderRadius: AppRadius.inputRadius,
            ),
            child: Row(
              children: [
                Icon(Icons.category, size: 12, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(tip.category,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.foreground)),
                const Spacer(),
                Icon(Icons.person, size: 12, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(tip.author,
                    style: TextStyle(
                        fontSize: 11, color: colors.mutedForeground)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Button.outline(
                  onPressed: () => _openTipDrawer(context, ref, tip),
                  child: const Text('Edit',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: tip.isActive
                    ? Button.secondary(
                        onPressed: () async {
                          tip.isActive = false;
                          await tip.save();
                          ref
                              .read(healthTipRefreshProvider.notifier)
                              .state++;
                        },
                        child: const Text('Unpublish',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      )
                    : Button.primary(
                        onPressed: () async {
                          tip.isActive = true;
                          tip.publishedAt = DateTime.now();
                          await tip.save();
                          ref
                              .read(healthTipRefreshProvider.notifier)
                              .state++;
                        },
                        child: const Text('Publish',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Button.destructive(
                onPressed: () async {
                  await tip.delete();
                  ref.read(healthTipRefreshProvider.notifier).state++;
                  if (!context.mounted) return;
                  showToast(
                      context: context,
                      builder: (c, o) => SurfaceCard(
                          child: Basic(
                              title: Text('"${tip.title}" removed'))));
                },
                child: const Icon(Icons.delete_outline, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openTipDrawer(
      BuildContext context, WidgetRef ref, HealthTipLocal? existing) {
    final colors = Theme.of(context).colorScheme;
    final isEdit = existing != null;
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final summaryCtrl =
        TextEditingController(text: existing?.summary ?? '');
    final contentCtrl =
        TextEditingController(text: existing?.content ?? '');
    final authorCtrl =
        TextEditingController(text: existing?.author ?? '');
    String category = existing?.category ?? 'wellness';

    final categories = [
      'wellness',
      'cardiovascular',
      'prevention',
      'chronic-disease',
      'mental-health',
      'nutrition',
    ];

    openDrawer(
      context: context,
      position: OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDrawerState) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEdit ? 'Edit Health Tip' : 'New Health Tip',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.foreground)),
              const SizedBox(height: 20),
              TextField(
                  controller: titleCtrl,
                  placeholder: const Text('Title')),
              const SizedBox(height: 12),
              TextField(
                  controller: summaryCtrl,
                  placeholder: const Text('Short summary...'),
                  maxLines: 2),
              const SizedBox(height: 12),
              TextField(
                  controller: contentCtrl,
                  placeholder: const Text('Full content...'),
                  maxLines: 4),
              const SizedBox(height: 12),
              TextField(
                  controller: authorCtrl,
                  placeholder: const Text('Author name')),
              const SizedBox(height: 16),
              Text('Category',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.mutedForeground)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((c) {
                  final isSelected = category == c;
                  return GestureDetector(
                    onTap: () =>
                        setDrawerState(() => category = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary
                            : colors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isSelected
                                ? colors.primary
                                : colors.border),
                      ),
                      child: Text(c,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? colors.primaryForeground
                                  : colors.mutedForeground)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Button.primary(
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    if (title.isEmpty) {
                      closeDrawer(context);
                      return;
                    }
                    final now = DateTime.now();

                    if (isEdit) {
                      existing
                        ..title = title
                        ..summary = summaryCtrl.text.trim()
                        ..content = contentCtrl.text.trim()
                        ..author = authorCtrl.text.trim()
                        ..category = category;
                      await existing.save();
                    } else {
                      final tip = HealthTipLocal()
                        ..title = title
                        ..summary = summaryCtrl.text.trim()
                        ..content = contentCtrl.text.trim()
                        ..category = category
                        ..author = authorCtrl.text.trim().isNotEmpty
                            ? authorCtrl.text.trim()
                            : 'Admin'
                        ..isActive = true
                        ..publishedAt = now
                        ..createdAt = now
                        ..syncStatus = 1;
                      await DatabaseService.healthTips.add(tip);
                    }

                    ref
                        .read(healthTipRefreshProvider.notifier)
                        .state++;

                    if (!context.mounted) return;
                    closeDrawer(context);
                    showToast(
                        context: context,
                        builder: (c, o) => SurfaceCard(
                            child: Basic(
                                title: Text(isEdit
                                    ? '"$title" updated'
                                    : '"$title" published'))));
                  },
                  child: Text(isEdit ? 'Save Changes' : 'Publish Tip'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
