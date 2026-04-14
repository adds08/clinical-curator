import 'package:hive_ce/hive.dart';

part 'slot_collection.g.dart';

@HiveType(typeId: 20)
class SlotLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String scheduleRef;

  @HiveField(3)
  late String status; // free, busy, busy-unavailable, busy-tentative, entered-in-error

  @HiveField(4)
  late DateTime startTime;

  @HiveField(5)
  late DateTime endTime;

  @HiveField(6)
  String? serviceType;

  @HiveField(7)
  String? practitionerRef;

  @HiveField(8)
  String? organizationRef;

  @HiveField(9)
  int? maxPatients;

  @HiveField(10)
  int? bookedCount;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  DateTime? updatedAt;

  @HiveField(13)
  late int syncStatus;
}
