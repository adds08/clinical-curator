import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class InsuranceEndpoint extends Endpoint {
  /// Submit a new insurance claim.
  Future<InsuranceClaim> submitClaim(
    Session session,
    InsuranceClaim claim,
  ) async {
    final record = claim.copyWith(
      status: 'submitted',
      createdAt: DateTime.now(),
    );
    return await InsuranceClaim.db.insertRow(session, record);
  }

  /// List claims for a patient.
  Future<List<InsuranceClaim>> listClaims(
    Session session,
    String patientRef,
  ) async {
    return await InsuranceClaim.db.find(
      session,
      where: (t) => t.patientRef.equals(patientRef),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Update claim status.
  Future<InsuranceClaim> updateStatus(
    Session session,
    int id,
    String status,
  ) async {
    final claim = await InsuranceClaim.db.findById(session, id);
    if (claim == null) throw NotFoundException('Claim not found.');
    final updated = claim.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    return await InsuranceClaim.db.updateRow(session, updated);
  }

  /// Get claim by ID.
  Future<InsuranceClaim?> getById(Session session, int id) async {
    return await InsuranceClaim.db.findById(session, id);
  }
}
