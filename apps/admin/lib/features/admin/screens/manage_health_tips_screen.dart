import 'package:clinical_curator_client/clinical_curator_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:cc_core/constants/app_spacing.dart';
import 'package:cc_core/constants/app_radius.dart';
import 'package:cc_core/theme/surface_theme.dart';
import 'package:cc_core/theme/clinical_colors.dart';

import '../../../domain/providers/repository_providers.dart';
import '../../../domain/providers/serverpod_provider.dart';

final _tipsProvider = FutureProvider.autoDispose<List<HealthTip>>((ref) {
  ref.watch(repoRefreshProvider);
  return ref.read(serverpodClientProvider).healthTip.listAllAdmin();
});

class ManageHealthTipsScreen extends ConsumerWidget {
  const ManageHealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final tipsAsync = ref.watch(_tipsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      child: SafeArea(
        child: tipsAsync.when(
          loading: () => const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text('Failed to load health tips: $e', style: TextStyle(color: colors.destructive)),
            ),
          ),
          data: (tips) => _buildContent(context, ref, tips),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<HealthTip> tips) {
    final colors = Theme.of(context).colorScheme;
    final activeCount = tips.where((t) => t.isActive).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Tips',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.foreground, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 2),
                  Text('$activeCount active of ${tips.length} total', style: TextStyle(fontSize: 12, color: colors.mutedForeground)),
                ],
              ),
              Button.primary(
                onPressed: () => _openTipDrawer(context, ref, null),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16),
                    SizedBox(width: 4),
                    Text('New Tip', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (tips.isEmpty)
            Card(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
              borderRadius: AppRadius.cardRadius,
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.lightbulb_outline, size: 36, color: colors.mutedForeground.withValues(alpha: 0.4)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No health tips yet',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.mutedForeground),
                    ),
                  ],
                ),
              ),
            )
          else
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _buildTipCard(context, ref, tip),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, WidgetRef ref, HealthTip tip) {
    final colors = Theme.of(context).colorScheme;
    final client = ref.read(serverpodClientProvider);

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
                child: Text(
                  tip.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: colors.foreground),
                ),
              ),
              tip.isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: colors.successBackground, borderRadius: AppRadius.chipRadius),
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: colors.success, letterSpacing: 0.5),
                      ),
                    )
                  : const SecondaryBadge(child: Text('DRAFT')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            tip.summary,
            style: TextStyle(fontSize: 12, color: colors.mutedForeground, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: SurfaceTheme.colorFor(SurfaceLevel.low, context), borderRadius: AppRadius.inputRadius),
            child: Row(
              children: [
                Icon(Icons.category, size: 12, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(
                  tip.category,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.foreground),
                ),
                const Spacer(),
                Icon(Icons.person, size: 12, color: colors.mutedForeground),
                const SizedBox(width: 4),
                Text(tip.author, style: TextStyle(fontSize: 11, color: colors.mutedForeground)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Button.outline(
                  onPressed: () => _openTipDrawer(context, ref, tip),
                  child: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: tip.isActive
                    ? Button.secondary(
                        onPressed: () async {
                          await client.healthTip.update(tip.copyWith(isActive: false));
                          bumpRepos(ref);
                        },
                        child: const Text('Unpublish', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      )
                    : Button.primary(
                        onPressed: () async {
                          await client.healthTip.update(tip.copyWith(isActive: true, publishedAt: DateTime.now()));
                          bumpRepos(ref);
                        },
                        child: const Text('Publish', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Button.destructive(
                onPressed: () async {
                  if (tip.id == null) return;
                  await client.healthTip.delete(tip.id!);
                  bumpRepos(ref);
                  if (!context.mounted) return;
                  showToast(
                    context: context,
                    builder: (c, o) => SurfaceCard(child: Basic(title: Text('"${tip.title}" removed'))),
                  );
                },
                child: const Icon(Icons.delete_outline, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openTipDrawer(BuildContext context, WidgetRef ref, HealthTip? existing) {
    final colors = Theme.of(context).colorScheme;
    final isEdit = existing != null;
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final summaryCtrl = TextEditingController(text: existing?.summary ?? '');
    final contentCtrl = TextEditingController(text: existing?.content ?? '');
    final authorCtrl = TextEditingController(text: existing?.author ?? '');
    String category = existing?.category ?? 'wellness';

    final categories = ['wellness', 'cardiovascular', 'prevention', 'chronic-disease', 'mental-health', 'nutrition'];

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
              Text(
                isEdit ? 'Edit Health Tip' : 'New Health Tip',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.foreground),
              ),
              const SizedBox(height: 20),
              TextField(controller: titleCtrl, placeholder: const Text('Title')),
              const SizedBox(height: 12),
              TextField(controller: summaryCtrl, placeholder: const Text('Short summary...'), maxLines: 2),
              const SizedBox(height: 12),
              TextField(controller: contentCtrl, placeholder: const Text('Full content...'), maxLines: 4),
              const SizedBox(height: 12),
              TextField(controller: authorCtrl, placeholder: const Text('Author name')),
              const SizedBox(height: 16),
              Text(
                'Category',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.mutedForeground),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((c) {
                  final isSelected = category == c;
                  return GestureDetector(
                    onTap: () => setDrawerState(() => category = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : colors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isSelected ? colors.primary : colors.border),
                      ),
                      child: Text(
                        c,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? colors.primaryForeground : colors.mutedForeground,
                        ),
                      ),
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
                    final client = ref.read(serverpodClientProvider);
                    try {
                      if (isEdit) {
                        await client.healthTip.update(
                          existing.copyWith(
                            title: title,
                            summary: summaryCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            author: authorCtrl.text.trim().isNotEmpty ? authorCtrl.text.trim() : existing.author,
                            category: category,
                          ),
                        );
                      } else {
                        await client.healthTip.create(
                          HealthTip(
                            title: title,
                            summary: summaryCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            category: category,
                            author: authorCtrl.text.trim().isNotEmpty ? authorCtrl.text.trim() : 'Admin',
                            isActive: true,
                            publishedAt: now,
                            createdAt: now,
                          ),
                        );
                      }
                      bumpRepos(ref);
                      if (!context.mounted) return;
                      closeDrawer(context);
                      showToast(
                        context: context,
                        builder: (c, o) => SurfaceCard(child: Basic(title: Text(isEdit ? '"$title" updated' : '"$title" published'))),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      showToast(
                        context: context,
                        builder: (c, o) => SurfaceCard(
                          child: Basic(title: const Text('Save failed'), subtitle: Text(e.toString())),
                        ),
                      );
                    }
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
