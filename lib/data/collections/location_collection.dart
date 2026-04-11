import 'package:hive_ce/hive.dart';

part 'location_collection.g.dart';

@HiveType(typeId: 17)
class LocationLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String type; // building, wing, ward, room, bed, area

  @HiveField(4)
  String? description;

  @HiveField(5)
  String? address;

  @HiveField(6)
  double? latitude;

  @HiveField(7)
  double? longitude;

  @HiveField(8)
  String? organizationRef;

  @HiveField(9)
  String? partOfRef; // parent location for hierarchy

  @HiveField(10)
  late String status; // active, suspended, inactive

  @HiveField(11)
  String? physicalType; // site, building, wing, ward, room, bed, vehicle

  @HiveField(12)
  late DateTime createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  late int syncStatus;
}
