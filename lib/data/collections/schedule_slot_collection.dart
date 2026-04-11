import 'package:hive_ce/hive.dart';

part 'schedule_slot_collection.g.dart';

@HiveType(typeId: 4)
class ScheduleSlotLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String practitionerRef;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String startTime;

  @HiveField(4)
  late String endTime;

  @HiveField(5)
  late int slotDurationMinutes;

  @HiveField(6)
  late int maxPatients;

  @HiveField(7)
  late int bookedCount;

  @HiveField(8)
  String? facilityName;

  @HiveField(9)
  late bool isEmergencyOverride;

  @HiveField(10)
  late bool isTelehealth;

  @HiveField(11)
  late String status;

  @HiveField(12)
  late DateTime createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
