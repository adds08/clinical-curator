import 'package:hive_ce/hive.dart';

part 'appointment_collection.g.dart';

@HiveType(typeId: 3)
class AppointmentLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String practitionerRef;

  @HiveField(4)
  late String practitionerName;

  @HiveField(5)
  late String patientName;

  @HiveField(6)
  late String appointmentType;

  @HiveField(7)
  late String status;

  @HiveField(8)
  late DateTime scheduledAt;

  @HiveField(9)
  late int durationMinutes;

  @HiveField(10)
  String? specialty;

  @HiveField(11)
  String? notes;

  @HiveField(12)
  late DateTime createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
