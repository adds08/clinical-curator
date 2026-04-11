import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/theme/glassmorphism.dart';
import '../../../core/theme/clinical_colors.dart';

/// Cardiovascular detail presented as a modal bottom sheet with glassmorphism.
/// Uses shadcn_flutter Card for metric cards and Button.primary for download.
/// Invoke via [CardiovascularDetailScreen.show(context)].
class CardiovascularDetailScreen extends StatelessWidget {
  const CardiovascularDetailScreen({super.key});

  /// Show the cardiovascular detail as a draggable modal bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CardiovascularDetailScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: AppRadius.sheetRadius,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(bottom: bottomPadding + AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragHandle(context),
                _buildTitleBar(context),
                const SizedBox(height: AppSpacing.xxl),
                _buildHeroMetrics(context),
                const SizedBox(height: AppSpacing.xxl),
                _buildHorizontalMetrics(context),
                const SizedBox(height: AppSpacing.xxxl),
                _buildDownloadButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Drag Handle
  // ---------------------------------------------------------------------------

  Widget _buildDragHandle(BuildContext context) {
      final colors = shadcn.Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colors.surfaceHigh,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Title Bar
  // ---------------------------------------------------------------------------

  Widget _buildTitleBar(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cardiovascular Health',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: colors.foreground,
              letterSpacing: -0.3,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, size: 18),
              color: colors.mutedForeground,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Hero Glassmorphic Metric Cards (HRV & BPM)
  // ---------------------------------------------------------------------------

  Widget _buildHeroMetrics(BuildContext context) {
      final colors = shadcn.Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Row(
        children: [
          Expanded(
            child: _buildGlassMetricCard(
              context: context,
              label: 'HRV',
              value: '86',
              unit: 'ms',
              icon: Icons.show_chart_rounded,
              iconColor: colors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildGlassMetricCard(
              context: context,
              label: 'BPM',
              value: '95',
              unit: 'bpm',
              icon: Icons.favorite_rounded,
              iconColor: colors.destructive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassMetricCard({
    required BuildContext context,
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
  }) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: Glassmorphism.decoration(
            borderRadius: AppRadius.xxl,
            borderOpacity: 0.25,
          ),
          child: shadcn.Card(
            padding: const EdgeInsets.all(AppSpacing.xl),
            fillColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color:
                            colors.mutedForeground.withValues(alpha: 0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(icon, size: 18, color: iconColor),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: colors.foreground,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            colors.mutedForeground.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Horizontal Scrollable Metric Cards
  // ---------------------------------------------------------------------------

  Widget _buildHorizontalMetrics(BuildContext context) {
      final colors = shadcn.Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            'DETAILED METRICS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: colors.mutedForeground.withValues(alpha: 0.5),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            children: [
              _buildDetailMetricCard(
                context: context,
                title: 'Blood Pressure',
                value: '120/80',
                unit: 'mmHg',
                status: 'Normal',
                statusColor: colors.success,
                icon: Icons.speed_rounded,
                iconColor: colors.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              _buildDetailMetricCard(
                context: context,
                title: 'Oxygen Saturation',
                value: '98',
                unit: '%',
                status: 'Normal',
                statusColor: colors.success,
                icon: Icons.air_rounded,
                iconColor: const Color(0xFF0891B2),
              ),
              const SizedBox(width: AppSpacing.md),
              _buildDetailMetricCard(
                context: context,
                title: 'Stress Level',
                value: 'Low',
                unit: '',
                status: 'Good',
                statusColor: colors.success,
                icon: Icons.self_improvement_rounded,
                iconColor: const Color(0xFF7C3AED),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconColor,
  }) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return SizedBox(
      width: 160,
      child: shadcn.Card(
        padding: const EdgeInsets.all(AppSpacing.lg),
        fillColor: colors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          colors.mutedForeground.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(icon, size: 16, color: iconColor),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: colors.foreground,
                    height: 1,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          colors.mutedForeground.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            shadcn.PrimaryBadge(
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Download Button
  // ---------------------------------------------------------------------------

  Widget _buildDownloadButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: SizedBox(
        width: double.infinity,
        child: shadcn.Button.primary(
          onPressed: () {
            shadcn.showToast(
              context: context,
              builder: (ctx, overlay) {
                return shadcn.SurfaceCard(
                  child: shadcn.Basic(
                    title: const Text('Health report downloaded'),
                    leading: const Icon(Icons.check_circle_outline_rounded),
                  ),
                );
              },
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download_rounded, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Download Health Report (PDF)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
