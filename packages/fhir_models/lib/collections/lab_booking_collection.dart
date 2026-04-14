import 'package:hive_ce/hive.dart';

part 'lab_booking_collection.g.dart';

@HiveType(typeId: 10)
class LabBookingLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String patientRef;

  @HiveField(2)
  late String testsJson;

  @HiveField(3)
  late String status;

  @HiveField(4)
  late double totalPrice;

  @HiveField(5)
  DateTime? scheduledAt;

  @HiveField(6)
  String? labName;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  late DateTime createdAt;

  @HiveField(9)
  DateTime? updatedAt;

  @HiveField(10)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
