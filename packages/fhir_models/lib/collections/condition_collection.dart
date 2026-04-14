import 'package:hive_ce/hive.dart';

part 'condition_collection.g.dart';

@HiveType(typeId: 12)
class ConditionLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String code; // SNOMED CT or ICD-10 code

  @HiveField(4)
  late String displayName;

  @HiveField(5)
  late String clinicalStatus; // active, recurrence, relapse, inactive, remission, resolved

  @HiveField(6)
  late String verificationStatus; // unconfirmed, provisional, differential, confirmed

  @HiveField(7)
  DateTime? onsetDate;

  @HiveField(8)
  DateTime? abatementDate;

  @HiveField(9)
  late DateTime recordedDate;

  @HiveField(10)
  String? severity; // mild, moderate, severe

  @HiveField(11)
  String? bodySite;

  @HiveField(12)
  String? encounterRef;

  @HiveField(13)
  String? recorderRef;

  @HiveField(14)
  String? notes;

  @HiveField(15)
  late DateTime createdAt;

  @HiveField(16)
  DateTime? updatedAt;

  @HiveField(17)
  late int syncStatus;
}
