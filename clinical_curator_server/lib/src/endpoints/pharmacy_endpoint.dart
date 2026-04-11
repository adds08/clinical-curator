import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class PharmacyEndpoint extends Endpoint {
  /// Create a pharmacy order.
  Future<PharmacyOrder> createOrder(
    Session session,
    PharmacyOrder order,
  ) async {
    final record = order.copyWith(
      status: 'pending',
      createdAt: DateTime.now(),
    );
    return await PharmacyOrder.db.insertRow(session, record);
  }

  /// List orders for a patient.
  Future<List<PharmacyOrder>> listOrders(
    Session session,
    String patientRef,
  ) async {
    return await PharmacyOrder.db.find(
      session,
      where: (t) => t.patientRef.equals(patientRef),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Update order status.
  Future<PharmacyOrder> updateStatus(
    Session session,
    int id,
    String status,
  ) async {
    final order = await PharmacyOrder.db.findById(session, id);
    if (order == null) throw NotFoundException('Order not found.');
    final updated = order.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    return await PharmacyOrder.db.updateRow(session, updated);
  }

  /// Get order by ID.
  Future<PharmacyOrder?> getById(Session session, int id) async {
    return await PharmacyOrder.db.findById(session, id);
  }
}
