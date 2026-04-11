import 'package:hive_ce/hive.dart';

part 'audit_event_collection.g.dart';

@HiveType(typeId: 23)
class AuditEventLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String type; // rest, user-auth, data-access, export, admin

  @HiveField(3)
  late String action; // create, read, update, delete, execute, login, logout

  @HiveField(4)
  late DateTime recorded;

  @HiveField(5)
  late String agentRef; // user ID who performed the action

  @HiveField(6)
  late String agentName;

  @HiveField(7)
  String? entityRef; // resource ID that was acted upon

  @HiveField(8)
  String? entityType; // Patient, Encounter, Appointment, etc.

  @HiveField(9)
  late String outcome; // success, failure

  @HiveField(10)
  String? detail;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  late int syncStatus;
}
