import 'package:hive_ce/hive.dart';

part 'pharmacy_order_collection.g.dart';

@HiveType(typeId: 5)
class PharmacyOrderLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String patientRef;

  @HiveField(2)
  late String pharmacyName;

  @HiveField(3)
  late String itemsJson;

  @HiveField(4)
  late String status;

  @HiveField(5)
  late double totalPrice;

  @HiveField(6)
  String? deliveryAddress;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  late DateTime createdAt;

  @HiveField(9)
  DateTime? updatedAt;

  @HiveField(10)
  late int syncStatus; // 0=synced, 1=pendingUpload, 2=pendingDelete
}
