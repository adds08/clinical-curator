import 'package:hive_ce/hive.dart';

part 'composition_collection.g.dart';

/// FHIR R4 Composition — wraps clinical notes with an attester entry,
/// turning a free-form note into a referenceable clinical document.
@HiveType(typeId: 27)
class CompositionLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  /// Composition.status — preliminary | final | amended | entered-in-error.
  @HiveField(2)
  late String status;

  /// LOINC code for Composition.type (e.g. "11506-3" Progress note).
  @HiveField(3)
  late String typeLoincCode;

  @HiveField(4)
  String? typeDisplay;

  @HiveField(5)
  late String subjectRef;

  @HiveField(6)
  String? encounterRef;

  @HiveField(7)
  late DateTime dateAuthored;

  @HiveField(8)
  late String authorPractitionerRef;

  @HiveField(9)
  String? authorPractitionerName;

  @HiveField(10)
  late String title;

  @HiveField(11)
  late String attesterPractitionerRef;

  @HiveField(12)
  late String attesterMode; // personal | professional | legal | official

  /// JSON-encoded list of Composition.section entries.
  @HiveField(13)
  String? sectionJson;

  /// Denormalized note body for quick lookup; section[0].text in FHIR.
  @HiveField(14)
  String? plainText;

  @HiveField(15)
  late DateTime createdAt;

  @HiveField(16)
  late int syncStatus;
}
