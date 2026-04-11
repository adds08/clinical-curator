// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rbac_permission_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RbacPermissionLocalAdapter extends TypeAdapter<RbacPermissionLocal> {
  @override
  final typeId = 24;

  @override
  RbacPermissionLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RbacPermissionLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..roleId = fields[1] as String
      ..roleName = fields[2] as String
      ..resource = fields[3] as String
      ..action = fields[4] as String
      ..isAllowed = fields[5] as bool
      ..createdAt = fields[6] as DateTime
      ..updatedAt = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, RbacPermissionLocal obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roleId)
      ..writeByte(2)
      ..write(obj.roleName)
      ..writeByte(3)
      ..write(obj.resource)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.isAllowed)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RbacPermissionLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
