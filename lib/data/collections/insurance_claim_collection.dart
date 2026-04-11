import 'package:hive_ce/hive.dart';

part 'insurance_claim_collection.g.dart';

@HiveType(typeId: 6)
class InsuranceClaimLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String patientRef;

  @HiveField(2)
  late String claimType;

  @HiveField(3)
  late String provider;

  @HiveField(4)
  late String policyNumber;

  @HiveField(5)
  late double amount;

  @HiveField(6)
  late String status;

  @HiveField(7)
  String? description;

  @HiveField(8)
  String? documentsJson;

  @HiveField(9)
  late DateTime createdAt;

  @HiveField(10)
  DateTime? updatedAt;

  @HiveField(11)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
