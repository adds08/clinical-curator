import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/health_tip_collection.dart';

/// Bump to force health tip providers to re-read from Hive.
final healthTipRefreshProvider = StateProvider<int>((ref) => 0);

/// Provides all active HealthTip records from Hive, sorted by publishedAt desc.
final healthTipsProvider = Provider<List<HealthTipLocal>>((ref) {
  ref.watch(healthTipRefreshProvider);
  final tips = DatabaseService.healthTips.values
      .where((t) => t.isActive)
      .toList()
    ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  return tips;
});

/// All health tips including inactive (for admin).
final allHealthTipsProvider = Provider<List<HealthTipLocal>>((ref) {
  ref.watch(healthTipRefreshProvider);
  final tips = DatabaseService.healthTips.values.toList()
    ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  return tips;
});

/// Lists health tips filtered by category.
final healthTipsByCategoryProvider =
    Provider.family<List<HealthTipLocal>, String>((ref, category) {
  ref.watch(healthTipRefreshProvider);
  final tips = DatabaseService.healthTips.values
      .where((t) => t.isActive && t.category == category)
      .toList()
    ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  return tips;
});
