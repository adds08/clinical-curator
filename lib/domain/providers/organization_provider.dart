import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/organization_collection.dart';

/// Bump to force organization providers to re-read from Hive.
final organizationRefreshProvider = StateProvider<int>((ref) => 0);

/// Provides all Organization records from Hive.
final organizationsProvider = Provider<List<OrganizationLocal>>((ref) {
  ref.watch(organizationRefreshProvider);
  return DatabaseService.organizations.values.toList();
});

/// Lists hospitals (type == 'hospital').
final hospitalsProvider = Provider<List<OrganizationLocal>>((ref) {
  ref.watch(organizationRefreshProvider);
  return DatabaseService.organizations.values
      .where((o) => o.type == 'hospital')
      .toList();
});

/// Lists pharmacies (type == 'pharmacy').
final pharmaciesProvider = Provider<List<OrganizationLocal>>((ref) {
  ref.watch(organizationRefreshProvider);
  return DatabaseService.organizations.values
      .where((o) => o.type == 'pharmacy')
      .toList();
});

/// Searches organizations by name (case-insensitive substring match).
final organizationSearchProvider =
    Provider.family<List<OrganizationLocal>, String>((ref, query) {
  ref.watch(organizationRefreshProvider);
  if (query.isEmpty) {
    return DatabaseService.organizations.values.toList();
  }
  final lowerQuery = query.toLowerCase();
  return DatabaseService.organizations.values
      .where((o) => o.name.toLowerCase().contains(lowerQuery))
      .toList();
});
