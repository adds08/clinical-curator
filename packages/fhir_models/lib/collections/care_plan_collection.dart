import 'package:hive_ce/hive.dart';

part 'care_plan_collection.g.dart';

@HiveType(typeId: 14)
class CarePlanLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String status; // draft, active, on-hold, revoked, completed, entered-in-error

  @HiveField(4)
  late String intent; // proposal, plan, order, option

  @HiveField(5)
  late String title;

  @HiveField(6)
  String? category;

  @HiveField(7)
  DateTime? periodStart;

  @HiveField(8)
  DateTime? periodEnd;

  @HiveField(9)
  String? activitiesJson; // JSON array of activities

  @HiveField(10)
  String? goalsJson; // JSON array of goals

  @HiveField(11)
  String? authorRef;

  @HiveField(12)
  String? encounterRef;

  @HiveField(13)
  String? notes;

  @HiveField(14)
  late DateTime createdAt;

  @HiveField(15)
  DateTime? updatedAt;

  @HiveField(16)
  late int syncStatus;
}
