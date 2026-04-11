import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class HealthTipEndpoint extends Endpoint {
  /// List all active health tips.
  Future<List<HealthTip>> listAll(
    Session session, {
    int? limit,
    int? offset,
  }) async {
    return await HealthTip.db.find(
      session,
      where: (t) => t.isActive.equals(true),
      orderBy: (t) => t.publishedAt,
      orderDescending: true,
      limit: limit ?? 20,
      offset: offset ?? 0,
    );
  }

  /// List active health tips by category.
  Future<List<HealthTip>> listByCategory(
    Session session,
    String category, {
    int? limit,
    int? offset,
  }) async {
    return await HealthTip.db.find(
      session,
      where: (t) => t.isActive.equals(true) & t.category.equals(category),
      orderBy: (t) => t.publishedAt,
      orderDescending: true,
      limit: limit ?? 20,
      offset: offset ?? 0,
    );
  }

  /// Get a health tip by ID.
  Future<HealthTip?> getById(Session session, int id) async {
    return await HealthTip.db.findById(session, id);
  }

  /// Create a health tip (admin).
  Future<HealthTip> create(Session session, HealthTip tip) async {
    final record = tip.copyWith(
      isActive: true,
      createdAt: DateTime.now(),
    );
    return await HealthTip.db.insertRow(session, record);
  }
}
