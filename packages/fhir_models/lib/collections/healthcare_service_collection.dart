import 'package:hive_ce/hive.dart';

part 'healthcare_service_collection.g.dart';

@HiveType(typeId: 18)
class HealthcareServiceLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String organizationRef;

  @HiveField(3)
  late String name;

  @HiveField(4)
  late String type; // emergency, cardiology-opd, lab, radiology, pharmacy, etc.

  @HiveField(5)
  String? specialty;

  @HiveField(6)
  String? availableTimeJson; // JSON array of available time slots

  @HiveField(7)
  String? locationRef;

  @HiveField(8)
  late bool active;

  @HiveField(9)
  String? comment;

  @HiveField(10)
  String? telecom; // contact phone/email

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  DateTime? updatedAt;

  @HiveField(13)
  late int syncStatus;
}
