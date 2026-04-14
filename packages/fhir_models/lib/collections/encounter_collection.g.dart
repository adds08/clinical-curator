// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EncounterLocalAdapter extends TypeAdapter<EncounterLocal> {
  @override
  final typeId = 11;

  @override
  EncounterLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EncounterLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..practitionerRef = fields[3] as String
      ..status = fields[4] as String
      ..classCode = fields[5] as String
      ..startDate = fields[6] as DateTime
      ..endDate = fields[7] as DateTime?
      ..organizationRef = fields[8] as String?
      ..reasonJson = fields[9] as String?
      ..serviceType = fields[10] as String?
      ..notes = fields[11] as String?
      ..patientName = fields[12] as String?
      ..practitionerName = fields[13] as String?
      ..createdAt = fields[14] as DateTime
      ..updatedAt = fields[15] as DateTime?
      ..syncStatus = (fields[16] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, EncounterLocal obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.practitionerRef)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.classCode)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.organizationRef)
      ..writeByte(9)
      ..write(obj.reasonJson)
      ..writeByte(10)
      ..write(obj.serviceType)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.patientName)
      ..writeByte(13)
      ..write(obj.practitionerName)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncounterLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
