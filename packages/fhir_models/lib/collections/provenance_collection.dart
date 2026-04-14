import 'package:hive_ce/hive.dart';

part 'provenance_collection.g.dart';

/// FHIR R4 Provenance — emitted when a clinician signs or attests to a
/// clinical resource (Encounter finalize, Composition attest, etc.).
@HiveType(typeId: 26)
class ProvenanceLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  /// `ResourceType/id` reference to the resource being attested.
  @HiveField(2)
  late String targetRef;

  @HiveField(3)
  late DateTime recordedAt;

  @HiveField(4)
  late String agentPractitionerRef;

  @HiveField(5)
  String? agentPractitionerName;

  /// CodeableConcept fields for PractitionerRole.code at time of signing.
  @HiveField(6)
  String? agentRoleSystem;

  @HiveField(7)
  String? agentRoleCode;

  @HiveField(8)
  String? agentRoleDisplay;

  /// Activity v3-DataOperation code: "AU" attest, "SIGN" signature.
  @HiveField(9)
  late String activityCode;

  @HiveField(10)
  String? signatureType;

  @HiveField(11)
  String? reasonText;

  @HiveField(12)
  late DateTime createdAt;

  @HiveField(13)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
