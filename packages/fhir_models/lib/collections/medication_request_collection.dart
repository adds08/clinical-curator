import 'package:hive_ce/hive.dart';

part 'medication_request_collection.g.dart';

@HiveType(typeId: 16)
class MedicationRequestLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String requesterRef;

  @HiveField(4)
  String? requesterName;

  @HiveField(5)
  late String medicationCode; // RxNorm code

  @HiveField(6)
  late String medicationName;

  @HiveField(7)
  late String status; // active, on-hold, cancelled, completed, entered-in-error, stopped, draft

  @HiveField(8)
  String? dosageJson; // JSON dosage instructions

  @HiveField(9)
  String? dispenseJson; // JSON dispense details (quantity, supply, refills)

  @HiveField(10)
  String? encounterRef;

  @HiveField(11)
  String? reasonJson;

  @HiveField(12)
  String? notes;

  @HiveField(13)
  late DateTime createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  @HiveField(15)
  late int syncStatus;
}
