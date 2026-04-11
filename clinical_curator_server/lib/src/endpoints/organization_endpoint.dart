import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../utils/validators.dart';

class OrganizationEndpoint extends Endpoint {
  /// List hospitals.
  Future<List<Organization>> listHospitals(Session session) async {
    return await Organization.db.find(
      session,
      where: (t) =>
          t.type.equals('hospital') | t.type.equals('government') | t.type.equals('private'),
      orderBy: (t) => t.name,
    );
  }

  /// List pharmacies.
  Future<List<Organization>> listPharmacies(Session session) async {
    return await Organization.db.find(
      session,
      where: (t) => t.type.equals('pharmacy'),
      orderBy: (t) => t.name,
    );
  }

  /// Search organizations by name (sanitized).
  Future<List<Organization>> search(
    Session session,
    String query,
  ) async {
    final sanitized = Validators.sanitizeSearchQuery(query);
    if (sanitized.isEmpty) return [];

    return await Organization.db.find(
      session,
      where: (t) => t.name.like('%$sanitized%'),
      orderBy: (t) => t.name,
    );
  }

  /// Get organization by ID.
  Future<Organization?> getById(Session session, int id) async {
    return await Organization.db.findById(session, id);
  }

  /// Create an organization (admin/seed).
  Future<Organization> create(
    Session session,
    Organization org,
  ) async {
    Validators.validateStringLength(org.name, 'Organization name');
    final record = org.copyWith(createdAt: DateTime.now());
    return await Organization.db.insertRow(session, record);
  }
}
