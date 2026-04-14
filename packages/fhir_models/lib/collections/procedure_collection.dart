import 'package:hive_ce/hive.dart';

part 'procedure_collection.g.dart';

@HiveType(typeId: 13)
class ProcedureLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  String? encounterRef;

  @HiveField(4)
  late String code; // SNOMED CT procedure code

  @HiveField(5)
  late String displayName;

  @HiveField(6)
  late String status; // preparation, in-progress, not-done, on-hold, stopped, completed

  @HiveField(7)
  DateTime? performedDate;

  @HiveField(8)
  String? performerRef;

  @HiveField(9)
  String? performerName;

  @HiveField(10)
  String? bodySite;

  @HiveField(11)
  String? notes;

  @HiveField(12)
  late DateTime createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  late int syncStatus;
}
