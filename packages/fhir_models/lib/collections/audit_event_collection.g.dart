// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_event_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuditEventLocalAdapter extends TypeAdapter<AuditEventLocal> {
  @override
  final typeId = 23;

  @override
  AuditEventLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditEventLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..type = fields[2] as String
      ..action = fields[3] as String
      ..recorded = fields[4] as DateTime
      ..agentRef = fields[5] as String
      ..agentName = fields[6] as String
      ..entityRef = fields[7] as String?
      ..entityType = fields[8] as String?
      ..outcome = fields[9] as String
      ..detail = fields[10] as String?
      ..createdAt = fields[11] as DateTime
      ..syncStatus = (fields[12] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, AuditEventLocal obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.recorded)
      ..writeByte(5)
      ..write(obj.agentRef)
      ..writeByte(6)
      ..write(obj.agentName)
      ..writeByte(7)
      ..write(obj.entityRef)
      ..writeByte(8)
      ..write(obj.entityType)
      ..writeByte(9)
      ..write(obj.outcome)
      ..writeByte(10)
      ..write(obj.detail)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuditEventLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
