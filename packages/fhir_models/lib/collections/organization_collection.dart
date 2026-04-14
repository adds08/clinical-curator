import 'package:hive_ce/hive.dart';

part 'organization_collection.g.dart';

@HiveType(typeId: 9)
class OrganizationLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String type;

  @HiveField(4)
  late String address;

  @HiveField(5)
  String? phone;

  @HiveField(6)
  double? latitude;

  @HiveField(7)
  double? longitude;

  @HiveField(8)
  String? openHours;

  @HiveField(9)
  double? rating;

  @HiveField(10)
  late bool hasEmergency;

  @HiveField(11)
  late bool isOpen24Hours;

  @HiveField(12)
  String? departmentsJson;

  @HiveField(13)
  String? servicesJson;

  @HiveField(14)
  late DateTime createdAt;

  @HiveField(15)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
