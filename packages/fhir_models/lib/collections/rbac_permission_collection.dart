import 'package:hive_ce/hive.dart';

part 'rbac_permission_collection.g.dart';

@HiveType(typeId: 24)
class RbacPermissionLocal extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  late String roleId; // patient, doctor, nurse, admin, or custom role ID

  @HiveField(2)
  late String roleName;

  @HiveField(3)
  late String resource; // patients, encounters, appointments, organizations, users, audit_log, settings, reports

  @HiveField(4)
  late String action; // read, create, update, delete, export

  @HiveField(5)
  late bool isAllowed;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  DateTime? updatedAt;
}
