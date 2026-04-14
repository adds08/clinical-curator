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

  // FHIR PractitionerRole.code is a CodeableConcept. We persist its three
  // primitive parts so we can round-trip without loss while keeping a fast
  // string key for RBAC and UI lookups.
  @HiveField(4)
  late String code; // CodeableConcept.coding[0].code — e.g. "doctor", "nurse"

  @HiveField(5)
  String? specialty;

  @HiveField(14)
  String? codeSystem; // CodeableConcept.coding[0].system

  @HiveField(15)
  String? codeDisplay; // CodeableConcept.coding[0].display

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
