import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class AmbulanceEndpoint extends Endpoint {
  /// Request an ambulance.
  Future<AmbulanceRequest> request(
    Session session,
    AmbulanceRequest request,
  ) async {
    final record = request.copyWith(
      status: 'requested',
      createdAt: DateTime.now(),
    );
    return await AmbulanceRequest.db.insertRow(session, record);
  }

  /// Update ambulance request status.
  Future<AmbulanceRequest> updateStatus(
    Session session,
    int id,
    String status, {
    String? driverName,
    String? vehicleNumber,
    int? estimatedMinutes,
    double? latitude,
    double? longitude,
  }) async {
    final existing = await AmbulanceRequest.db.findById(session, id);
    if (existing == null) throw NotFoundException('Request not found.');

    final updated = existing.copyWith(
      status: status,
      assignedDriverName: driverName ?? existing.assignedDriverName,
      assignedVehicleNumber: vehicleNumber ?? existing.assignedVehicleNumber,
      estimatedArrivalMinutes: estimatedMinutes ?? existing.estimatedArrivalMinutes,
      latitude: latitude ?? existing.latitude,
      longitude: longitude ?? existing.longitude,
      updatedAt: DateTime.now(),
    );
    return await AmbulanceRequest.db.updateRow(session, updated);
  }

  /// Cancel an ambulance request with a reason.
  Future<AmbulanceRequest> cancelWithReason(
    Session session,
    int id,
    String reason,
  ) async {
    final existing = await AmbulanceRequest.db.findById(session, id);
    if (existing == null) throw NotFoundException('Request not found.');
    final updated = existing.copyWith(
      status: 'cancelled',
      cancellationReason: reason,
      updatedAt: DateTime.now(),
    );
    return await AmbulanceRequest.db.updateRow(session, updated);
  }

  /// Complete an ambulance request with rating and feedback.
  Future<AmbulanceRequest> completeWithRating(
    Session session,
    int id,
    String timelinessRating,
    int helpfulnessRating, {
    String? feedbackNotes,
  }) async {
    final existing = await AmbulanceRequest.db.findById(session, id);
    if (existing == null) throw NotFoundException('Request not found.');
    final updated = existing.copyWith(
      status: 'completed',
      timelinessRating: timelinessRating,
      helpfulnessRating: helpfulnessRating,
      feedbackNotes: feedbackNotes,
      updatedAt: DateTime.now(),
    );
    return await AmbulanceRequest.db.updateRow(session, updated);
  }

  /// Get an ambulance request by ID.
  Future<AmbulanceRequest?> getById(Session session, int id) async {
    return await AmbulanceRequest.db.findById(session, id);
  }

  /// List ambulance requests for a patient.
  Future<List<AmbulanceRequest>> listForPatient(
    Session session,
    String patientRef,
  ) async {
    return await AmbulanceRequest.db.find(
      session,
      where: (t) => t.patientRef.equals(patientRef),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// List active ambulance requests (including arrived, awaiting confirmation).
  Future<List<AmbulanceRequest>> listActive(Session session) async {
    return await AmbulanceRequest.db.find(
      session,
      where: (t) =>
          t.status.equals('requested') |
          t.status.equals('dispatched') |
          t.status.equals('enroute') |
          t.status.equals('arrived'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }
}
