import 'package:hive_ce/hive.dart';

part 'practitioner_role_collection.g.dart';

@HiveType(typeId: 19)
class PractitionerRoleLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String practitionerRef;

  @HiveField(3)
  late String organizationRef;

  @HiveField(4)
  late String code; // doctor, nurse, pharmacist, etc.

  @HiveField(5)
  String? specialty;

  @HiveField(6)
  String? locationRefsJson; // JSON array of location references

  @HiveField(7)
  String? availableTimeJson; // JSON array of available time slots

  @HiveField(8)
  late bool active;

  @HiveField(9)
  String? practitionerName;

  @HiveField(10)
  String? organizationName;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  DateTime? updatedAt;

  @HiveField(13)
  late int syncStatus;
}
