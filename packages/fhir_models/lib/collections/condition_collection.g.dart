// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConditionLocalAdapter extends TypeAdapter<ConditionLocal> {
  @override
  final typeId = 12;

  @override
  ConditionLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConditionLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..code = fields[3] as String
      ..displayName = fields[4] as String
      ..clinicalStatus = fields[5] as String
      ..verificationStatus = fields[6] as String
      ..onsetDate = fields[7] as DateTime?
      ..abatementDate = fields[8] as DateTime?
      ..recordedDate = fields[9] as DateTime
      ..severity = fields[10] as String?
      ..bodySite = fields[11] as String?
      ..encounterRef = fields[12] as String?
      ..recorderRef = fields[13] as String?
      ..notes = fields[14] as String?
      ..createdAt = fields[15] as DateTime
      ..updatedAt = fields[16] as DateTime?
      ..syncStatus = (fields[17] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, ConditionLocal obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.displayName)
      ..writeByte(5)
      ..write(obj.clinicalStatus)
      ..writeByte(6)
      ..write(obj.verificationStatus)
      ..writeByte(7)
      ..write(obj.onsetDate)
      ..writeByte(8)
      ..write(obj.abatementDate)
      ..writeByte(9)
      ..write(obj.recordedDate)
      ..writeByte(10)
      ..write(obj.severity)
      ..writeByte(11)
      ..write(obj.bodySite)
      ..writeByte(12)
      ..write(obj.encounterRef)
      ..writeByte(13)
      ..write(obj.recorderRef)
      ..writeByte(14)
      ..write(obj.notes)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt)
      ..writeByte(17)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
