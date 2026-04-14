import 'package:hive_ce/hive.dart';

part 'user_account_collection.g.dart';

@HiveType(typeId: 0)
class UserAccount extends HiveObject {
  @HiveField(0)
  late String email;

  @HiveField(1)
  late String passwordHash;

  @HiveField(2)
  late String displayName;

  @HiveField(3)
  String? fhirPatientId;

  @HiveField(4)
  String? fhirPractitionerId;

  @HiveField(5)
  late bool isPractitioner;

  @HiveField(6)
  late bool isVerified;

  @HiveField(7)
  String? practitionerType;

  @HiveField(8)
  String? avatarUrl;

  @HiveField(9)
  String? healthId;

  @HiveField(10)
  late String accountType;

  @HiveField(11)
  late DateTime createdAt;

  @HiveField(12)
  DateTime? updatedAt;
}
