// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcedureLocalAdapter extends TypeAdapter<ProcedureLocal> {
  @override
  final typeId = 13;

  @override
  ProcedureLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProcedureLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..encounterRef = fields[3] as String?
      ..code = fields[4] as String
      ..displayName = fields[5] as String
      ..status = fields[6] as String
      ..performedDate = fields[7] as DateTime?
      ..performerRef = fields[8] as String?
      ..performerName = fields[9] as String?
      ..bodySite = fields[10] as String?
      ..notes = fields[11] as String?
      ..createdAt = fields[12] as DateTime
      ..updatedAt = fields[13] as DateTime?
      ..syncStatus = (fields[14] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, ProcedureLocal obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.encounterRef)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.displayName)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.performedDate)
      ..writeByte(8)
      ..write(obj.performerRef)
      ..writeByte(9)
      ..write(obj.performerName)
      ..writeByte(10)
      ..write(obj.bodySite)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcedureLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
