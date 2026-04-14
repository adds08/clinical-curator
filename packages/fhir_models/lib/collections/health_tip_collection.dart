import 'package:hive_ce/hive.dart';

part 'health_tip_collection.g.dart';

@HiveType(typeId: 8)
class HealthTipLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String summary;

  @HiveField(3)
  late String content;

  @HiveField(4)
  late String category;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  late String author;

  @HiveField(7)
  late bool isActive;

  @HiveField(8)
  late DateTime publishedAt;

  @HiveField(9)
  late DateTime createdAt;

  @HiveField(10)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
