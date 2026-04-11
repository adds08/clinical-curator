import 'package:hive_ce/hive.dart';

part 'fhir_resource_collection.g.dart';

@HiveType(typeId: 1)
class FhirResource extends HiveObject {
  @HiveField(0)
  late String fhirId;

  @HiveField(1)
  late String resourceType;

  @HiveField(2)
  late String jsonData;

  @HiveField(3)
  String? patientReference;

  @HiveField(4)
  String? practitionerReference;

  @HiveField(5)
  String? category;

  @HiveField(6)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete

  @HiveField(7)
  late bool isDownloadedOffline;

  @HiveField(8)
  late DateTime lastUpdated;

  @HiveField(9)
  DateTime? createdAt;
}
