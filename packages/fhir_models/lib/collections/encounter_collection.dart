import 'package:hive_ce/hive.dart';

part 'encounter_collection.g.dart';

@HiveType(typeId: 11)
class EncounterLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String practitionerRef;

  @HiveField(4)
  late String status; // planned, arrived, triaged, in-progress, onleave, finished, cancelled

  @HiveField(5)
  late String classCode; // AMB, EMER, IMP, OBSENC

  @HiveField(6)
  late DateTime startDate;

  @HiveField(7)
  DateTime? endDate;

  @HiveField(8)
  String? organizationRef;

  @HiveField(9)
  String? reasonJson; // JSON array of reason codes

  @HiveField(10)
  String? serviceType;

  @HiveField(11)
  String? notes;

  @HiveField(12)
  String? patientName;

  @HiveField(13)
  String? practitionerName;

  @HiveField(14)
  late DateTime createdAt;

  @HiveField(15)
  DateTime? updatedAt;

  @HiveField(16)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
