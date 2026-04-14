import 'package:hive_ce/hive.dart';

part 'allergy_intolerance_collection.g.dart';

@HiveType(typeId: 22)
class AllergyIntoleranceLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String code; // substance code

  @HiveField(4)
  late String displayName;

  @HiveField(5)
  late String clinicalStatus; // active, inactive, resolved

  @HiveField(6)
  late String verificationStatus; // unconfirmed, confirmed, refuted, entered-in-error

  @HiveField(7)
  late String type; // allergy, intolerance

  @HiveField(8)
  late String category; // food, medication, environment, biologic

  @HiveField(9)
  late String criticality; // low, high, unable-to-assess

  @HiveField(10)
  DateTime? onsetDate;

  @HiveField(11)
  String? reactionJson; // JSON array of reactions

  @HiveField(12)
  String? recorderRef;

  @HiveField(13)
  String? notes;

  @HiveField(14)
  late DateTime createdAt;

  @HiveField(15)
  DateTime? updatedAt;

  @HiveField(16)
  late int syncStatus;
}
