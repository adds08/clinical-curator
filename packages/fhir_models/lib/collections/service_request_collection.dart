import 'package:hive_ce/hive.dart';

part 'service_request_collection.g.dart';

@HiveType(typeId: 15)
class ServiceRequestLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late String requesterRef;

  @HiveField(4)
  String? requesterName;

  @HiveField(5)
  late String code; // LOINC for labs, SNOMED for procedures

  @HiveField(6)
  late String displayName;

  @HiveField(7)
  late String status; // draft, active, on-hold, revoked, completed, entered-in-error

  @HiveField(8)
  late String intent; // proposal, plan, directive, order, original-order, reflex-order, filler-order, instance-order, option

  @HiveField(9)
  late String priority; // routine, urgent, asap, stat

  @HiveField(10)
  String? category; // laboratory, imaging, referral, procedure

  @HiveField(11)
  String? encounterRef;

  @HiveField(12)
  DateTime? occurrenceDate;

  @HiveField(13)
  String? performerRef; // referred-to practitioner (for referrals)

  @HiveField(14)
  String? reasonJson;

  @HiveField(15)
  String? notes;

  @HiveField(16)
  late DateTime createdAt;

  @HiveField(17)
  DateTime? updatedAt;

  @HiveField(18)
  late int syncStatus;
}
