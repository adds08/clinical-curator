import 'package:hive_ce/hive.dart';

part 'notification_record_collection.g.dart';

@HiveType(typeId: 7)
class NotificationRecordLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String userEmail;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late String body;

  @HiveField(4)
  late String type;

  @HiveField(5)
  late bool isRead;

  @HiveField(6)
  String? relatedResourceId;

  @HiveField(7)
  String? relatedRoute;

  @HiveField(8)
  late DateTime createdAt;

  @HiveField(9)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
