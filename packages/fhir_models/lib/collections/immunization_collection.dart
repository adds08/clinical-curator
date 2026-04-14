import 'package:hive_ce/hive.dart';

part 'immunization_collection.g.dart';

@HiveType(typeId: 21)
class ImmunizationLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String vaccineCode; // CVX code

  @HiveField(4)
  late String vaccineName;

  @HiveField(5)
  late DateTime occurrenceDate;

  @HiveField(6)
  late String status; // completed, entered-in-error, not-done

  @HiveField(7)
  String? lotNumber;

  @HiveField(8)
  String? site; // left arm, right arm, etc.

  @HiveField(9)
  String? routeOfAdmin; // intramuscular, subcutaneous, oral, etc.

  @HiveField(10)
  String? doseQuantity;

  @HiveField(11)
  String? performerRef;

  @HiveField(12)
  String? notes;

  @HiveField(13)
  late DateTime createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  @HiveField(15)
  late int syncStatus;
}
