// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provenance_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProvenanceLocalAdapter extends TypeAdapter<ProvenanceLocal> {
  @override
  final typeId = 26;

  @override
  ProvenanceLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProvenanceLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..targetRef = fields[2] as String
      ..recordedAt = fields[3] as DateTime
      ..agentPractitionerRef = fields[4] as String
      ..agentPractitionerName = fields[5] as String?
      ..agentRoleSystem = fields[6] as String?
      ..agentRoleCode = fields[7] as String?
      ..agentRoleDisplay = fields[8] as String?
      ..activityCode = fields[9] as String
      ..signatureType = fields[10] as String?
      ..reasonText = fields[11] as String?
      ..createdAt = fields[12] as DateTime
      ..syncStatus = (fields[13] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, ProvenanceLocal obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.targetRef)
      ..writeByte(3)
      ..write(obj.recordedAt)
      ..writeByte(4)
      ..write(obj.agentPractitionerRef)
      ..writeByte(5)
      ..write(obj.agentPractitionerName)
      ..writeByte(6)
      ..write(obj.agentRoleSystem)
      ..writeByte(7)
      ..write(obj.agentRoleCode)
      ..writeByte(8)
      ..write(obj.agentRoleDisplay)
      ..writeByte(9)
      ..write(obj.activityCode)
      ..writeByte(10)
      ..write(obj.signatureType)
      ..writeByte(11)
      ..write(obj.reasonText)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProvenanceLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
