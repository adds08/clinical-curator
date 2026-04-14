import 'package:hive_ce/hive.dart';

part 'payment_collection.g.dart';

@HiveType(typeId: 25)
class PaymentLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? fhirId;

  @HiveField(2)
  late String patientRef;

  @HiveField(3)
  late double amount;

  @HiveField(4)
  late String currency; // NPR

  @HiveField(5)
  late String status; // pending, processing, completed, failed, refunded

  @HiveField(6)
  late String method; // esewa, khalti, cash

  @HiveField(7)
  String? gateway; // esewa, khalti

  @HiveField(8)
  String? transactionId;

  @HiveField(9)
  String? appointmentRef;

  @HiveField(10)
  String? description;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  DateTime? updatedAt;

  @HiveField(13)
  late int syncStatus;
}
