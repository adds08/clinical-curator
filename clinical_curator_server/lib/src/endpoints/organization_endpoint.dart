import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';
import '../utils/validators.dart';

class OrganizationEndpoint extends Endpoint {
  Future<List<Organization>> listAll(Session session) async {
    return await Organization.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  Future<List<Organization>> listHospitals(Session session) async {
    return await Organization.db.find(
      session,
      where: (t) =>
          t.type.equals('hospital') |
          t.type.equals('government') |
          t.type.equals('private'),
      orderBy: (t) => t.name,
    );
  }

  Future<List<Organization>> listPharmacies(Session session) async {
    return await Organization.db.find(
      session,
      where: (t) => t.type.equals('pharmacy'),
      orderBy: (t) => t.name,
    );
  }

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

  Future<Organization?> getById(Session session, int id) async {
    return await Organization.db.findById(session, id);
  }

  Future<Organization> create(Session session, Organization org) async {
    Validators.validateStringLength(org.name, 'Organization name');
    final record = org.copyWith(createdAt: DateTime.now());
    return await Organization.db.insertRow(session, record);
  }

  Future<Organization> update(Session session, Organization org) async {
    if (org.id == null) {
      throw ValidationException('Organization.id is required for update.');
    }
    Validators.validateStringLength(org.name, 'Organization name');
    return await Organization.db.updateRow(session, org);
  }

  Future<bool> delete(Session session, int id) async {
    final existing = await Organization.db.findById(session, id);
    if (existing == null) return false;
    await Organization.db.deleteRow(session, existing);
    return true;
  }
}
