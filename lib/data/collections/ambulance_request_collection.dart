import 'package:hive_ce/hive.dart';

part 'ambulance_request_collection.g.dart';

@HiveType(typeId: 2)
class AmbulanceRequestLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String patientRef;

  @HiveField(2)
  late String patientName;

  @HiveField(3)
  late String contactNumber;

  @HiveField(4)
  late String emergencyType;

  @HiveField(5)
  late String pickupLocation;

  @HiveField(6)
  late String status;

  @HiveField(7)
  double? latitude;

  @HiveField(8)
  double? longitude;

  @HiveField(9)
  String? assignedDriverName;

  @HiveField(10)
  String? assignedVehicleNumber;

  @HiveField(11)
  int? estimatedArrivalMinutes;

  @HiveField(12)
  String? notes;

  @HiveField(13)
  late DateTime createdAt;

  @HiveField(14)
  DateTime? updatedAt;

  @HiveField(15)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete

  @HiveField(16)
  String? cancellationReason;

  @HiveField(17)
  String? timelinessRating; // 'early', 'on_time', 'delayed'

  @HiveField(18)
  int? helpfulnessRating; // 1-5

  @HiveField(19)
  String? feedbackNotes;
}
