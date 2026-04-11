import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/surface_theme.dart';
import '../../../data/collections/health_tip_collection.dart';
import '../../../domain/providers/health_tip_provider.dart';
import '../../shared/widgets/sub_page_scaffold.dart';
import '../../../core/theme/clinical_colors.dart';

class HealthTipsScreen extends ConsumerStatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  ConsumerState<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends ConsumerState<HealthTipsScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final allTips = ref.watch(healthTipsProvider);

    // Build category list from data
    final categories = <String>{'All'};
    for (final t in allTips) {
      categories.add(t.category);
    }
    final categoryList = categories.toList();

    // Filter
    var tips = allTips;
    if (_selectedCategory != 'All') {
      tips = tips.where((t) => t.category == _selectedCategory).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      tips = tips
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              t.summary.toLowerCase().contains(q))
          .toList();
    }

    final featured = tips.isNotEmpty ? tips.first : null;
    final rest = tips.length > 1 ? tips.sublist(1) : <HealthTipLocal>[];

    return SubPageScaffold(
      title: 'Health Tips',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            shadcn.TextField(
              controller: _searchController,
              placeholder: const Text('Search articles...'),
              onChanged: (_) => setState(() {}),
              features: [
                shadcn.InputFeature.leading(
                    Icon(Icons.search, color: colors.mutedForeground, size: 20)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Category chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final selected = categoryList[i] == _selectedCategory;
                  return shadcn.Chip(
                    onPressed: () =>
                        setState(() => _selectedCategory = categoryList[i]),
                    child: Text(
                      categoryList[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? colors.primary : colors.mutedForeground,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Featured article
            if (featured != null) ...[
              GestureDetector(
                onTap: () => _openArticle(context, featured),
                child: shadcn.Card(
                  padding: EdgeInsets.zero,
                  fillColor:
                      SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colors.primary.withValues(alpha: 0.15),
                              colors.primary.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_iconForCategory(featured.category),
                                color: colors.primary, size: 36),
                            const SizedBox(height: 4),
                            Text('Featured',
                                style: TextStyle(
                                    fontSize: 11, color: colors.primary)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shadcn.PrimaryBadge(
                                child: Text(featured.category.toUpperCase())),
                            const SizedBox(height: AppSpacing.sm),
                            Text(featured.title,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: colors.foreground,
                                    letterSpacing: -0.3,
                                    height: 1.3)),
                            const SizedBox(height: AppSpacing.sm),
                            Text(featured.summary,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: colors.mutedForeground,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // Article grid
            if (rest.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.78,
                ),
                itemCount: rest.length,
                itemBuilder: (context, i) => _buildArticleCard(rest[i]),
              ),

            if (tips.isEmpty)
              shadcn.Card(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                fillColor:
                    SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 36,
                          color:
                              colors.mutedForeground.withValues(alpha: 0.4)),
                      const SizedBox(height: AppSpacing.md),
                      Text('No health tips available',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.mutedForeground)),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Newsletter signup
            shadcn.Card(
              padding: const EdgeInsets.all(AppSpacing.xl),
              fillColor: colors.primary.withValues(alpha: 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.mail_outline, color: colors.primary, size: 22),
                      const SizedBox(width: AppSpacing.sm),
                      Text('Clinical Digest',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.foreground)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                      'Weekly curated health insights delivered to your inbox.',
                      style: TextStyle(
                          fontSize: 13,
                          color: colors.mutedForeground,
                          height: 1.4)),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: shadcn.TextField(
                          controller: _emailController,
                          placeholder: const Text('you@email.com'),
                          features: [
                            shadcn.InputFeature.leading(Icon(
                                Icons.email_outlined,
                                color: colors.mutedForeground,
                                size: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      shadcn.Button.primary(
                        onPressed: () {
                          shadcn.showToast(
                            context: context,
                            builder: (ctx, overlay) => shadcn.SurfaceCard(
                              child: shadcn.Basic(
                                leading: Icon(Icons.check_circle,
                                    color: colors.success),
                                title: const Text(
                                    'Subscribed to Clinical Digest'),
                              ),
                            ),
                          );
                        },
                        child: const Text('Subscribe'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _openArticle(BuildContext context, HealthTipLocal tip) {
    final colors = shadcn.Theme.of(context).colorScheme;
    shadcn.openDrawer(
      context: context,
      position: shadcn.OverlayPosition.bottom,
      showDragHandle: true,
      draggable: true,
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                shadcn.SecondaryBadge(child: Text(tip.category)),
                const SizedBox(width: 8),
                Text('By ${tip.author}',
                    style: TextStyle(
                        fontSize: 12, color: colors.mutedForeground)),
              ],
            ),
            const SizedBox(height: 12),
            Text(tip.title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.foreground,
                    height: 1.3,
                    letterSpacing: -0.3)),
            const SizedBox(height: 8),
            Text(tip.summary,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.mutedForeground,
                    height: 1.4)),
            const SizedBox(height: 16),
            Text(tip.content,
                style: TextStyle(
                    fontSize: 14,
                    color: colors.foreground,
                    height: 1.6)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: shadcn.Button.outline(
                onPressed: () => shadcn.closeDrawer(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(HealthTipLocal tip) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _openArticle(context, tip),
      child: shadcn.Card(
        padding: EdgeInsets.zero,
        fillColor: SurfaceTheme.colorFor(SurfaceLevel.lowest, context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.primary.withValues(alpha: 0.12),
                    colors.primary.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(_iconForCategory(tip.category),
                  color: colors.primary.withValues(alpha: 0.6), size: 28),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shadcn.SecondaryBadge(child: Text(tip.category)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(tip.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                          height: 1.3)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(tip.author,
                      style: TextStyle(
                          fontSize: 10, color: colors.mutedForeground)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'cardiovascular':
        return Icons.favorite;
      case 'wellness':
        return Icons.spa;
      case 'prevention':
        return Icons.health_and_safety;
      case 'chronic-disease':
        return Icons.medical_information;
      case 'mental-health':
        return Icons.self_improvement;
      case 'nutrition':
        return Icons.restaurant;
      default:
        return Icons.lightbulb_outline;
    }
  }
}
