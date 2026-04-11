import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/notification_record_collection.dart';

class NotificationState {
  final List<NotificationRecordLocal> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    List<NotificationRecordLocal>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState());

  Future<void> createNotification({
    required String userEmail,
    required String title,
    required String body,
    required String type,
    String? relatedResourceId,
    String? relatedRoute,
  }) async {
    try {
      final box = DatabaseService.notificationRecords;
      final now = DateTime.now();

      final notification = NotificationRecordLocal()
        ..userEmail = userEmail
        ..title = title
        ..body = body
        ..type = type
        ..isRead = false
        ..relatedResourceId = relatedResourceId
        ..relatedRoute = relatedRoute
        ..createdAt = now
        ..syncStatus = 1;

      await box.add(notification);

      _refreshForUser(userEmail);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to create notification: $e',
      );
    }
  }

  Future<void> markAsRead(int hiveKey) async {
    try {
      final box = DatabaseService.notificationRecords;
      final notification = box.get(hiveKey);
      if (notification == null) return;

      notification
        ..isRead = true
        ..syncStatus = 1;

      await notification.save();

      _refreshForUser(notification.userEmail);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to mark notification as read: $e',
      );
    }
  }

  Future<void> markAllAsRead(String userEmail) async {
    try {
      final box = DatabaseService.notificationRecords;

      for (final n in box.values) {
        if (n.userEmail == userEmail && !n.isRead) {
          n
            ..isRead = true
            ..syncStatus = 1;
          await n.save();
        }
      }

      _refreshForUser(userEmail);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to mark all notifications as read: $e',
      );
    }
  }

  int getUnreadCount(String userEmail) {
    final box = DatabaseService.notificationRecords;
    return box.values
        .where((n) => n.userEmail == userEmail && !n.isRead)
        .length;
  }

  void listForUser(String userEmail) {
    _refreshForUser(userEmail);
  }

  void _refreshForUser(String userEmail) {
    final box = DatabaseService.notificationRecords;
    final results = box.values
        .where((n) => n.userEmail == userEmail)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final unread = results.where((n) => !n.isRead).length;

    state = state.copyWith(
      notifications: results,
      unreadCount: unread,
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});
