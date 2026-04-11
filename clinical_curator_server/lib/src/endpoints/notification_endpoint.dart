import 'package:serverpod/serverpod.dart';

import '../errors/app_exceptions.dart';
import '../generated/protocol.dart';

class NotificationEndpoint extends Endpoint {
  /// Create a notification.
  Future<NotificationRecord> create(
    Session session,
    NotificationRecord notification,
  ) async {
    final record = notification.copyWith(
      isRead: false,
      createdAt: DateTime.now(),
    );
    return await NotificationRecord.db.insertRow(session, record);
  }

  /// List notifications for a user.
  Future<List<NotificationRecord>> listForUser(
    Session session,
    String userEmail,
  ) async {
    return await NotificationRecord.db.find(
      session,
      where: (t) => t.userEmail.equals(userEmail),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 50,
    );
  }

  /// Mark a notification as read.
  Future<NotificationRecord> markAsRead(Session session, int id) async {
    final notification = await NotificationRecord.db.findById(session, id);
    if (notification == null) {
      throw NotFoundException('Notification not found.');
    }
    final updated = notification.copyWith(isRead: true);
    return await NotificationRecord.db.updateRow(session, updated);
  }

  /// Mark all notifications as read for a user.
  Future<void> markAllAsRead(Session session, String userEmail) async {
    final unread = await NotificationRecord.db.find(
      session,
      where: (t) =>
          t.userEmail.equals(userEmail) & t.isRead.equals(false),
    );
    for (final n in unread) {
      await NotificationRecord.db.updateRow(
        session,
        n.copyWith(isRead: true),
      );
    }
  }

  /// Get unread count for a user.
  Future<int> getUnreadCount(Session session, String userEmail) async {
    return await NotificationRecord.db.count(
      session,
      where: (t) =>
          t.userEmail.equals(userEmail) & t.isRead.equals(false),
    );
  }
}
