import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class HealthTipEndpoint extends Endpoint {
  /// List active health tips.
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

  /// Admin view: list every health tip regardless of `isActive`.
  Future<List<HealthTip>> listAllAdmin(Session session) async {
    return await HealthTip.db.find(
      session,
      orderBy: (t) => t.publishedAt,
      orderDescending: true,
    );
  }

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

  Future<HealthTip?> getById(Session session, int id) async {
    return await HealthTip.db.findById(session, id);
  }

  Future<HealthTip> create(Session session, HealthTip tip) async {
    final record = tip.copyWith(
      isActive: tip.isActive,
      createdAt: tip.createdAt,
    );
    return await HealthTip.db.insertRow(session, record);
  }

  Future<HealthTip> update(Session session, HealthTip tip) async {
    if (tip.id == null) {
      throw ValidationException('HealthTip.id is required for update.');
    }
    return await HealthTip.db.updateRow(session, tip);
  }

  Future<bool> delete(Session session, int id) async {
    final existing = await HealthTip.db.findById(session, id);
    if (existing == null) return false;
    await HealthTip.db.deleteRow(session, existing);
    return true;
  }
}
