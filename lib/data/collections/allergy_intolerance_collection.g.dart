// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allergy_intolerance_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllergyIntoleranceLocalAdapter
    extends TypeAdapter<AllergyIntoleranceLocal> {
  @override
  final typeId = 22;

  @override
  AllergyIntoleranceLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllergyIntoleranceLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..code = fields[3] as String
      ..displayName = fields[4] as String
      ..clinicalStatus = fields[5] as String
      ..verificationStatus = fields[6] as String
      ..type = fields[7] as String
      ..category = fields[8] as String
      ..criticality = fields[9] as String
      ..onsetDate = fields[10] as DateTime?
      ..reactionJson = fields[11] as String?
      ..recorderRef = fields[12] as String?
      ..notes = fields[13] as String?
      ..createdAt = fields[14] as DateTime
      ..updatedAt = fields[15] as DateTime?
      ..syncStatus = (fields[16] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, AllergyIntoleranceLocal obj) {
    writer
      ..writeByte(17)
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
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.criticality)
      ..writeByte(10)
      ..write(obj.onsetDate)
      ..writeByte(11)
      ..write(obj.reactionJson)
      ..writeByte(12)
      ..write(obj.recorderRef)
      ..writeByte(13)
      ..write(obj.notes)
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
      other is AllergyIntoleranceLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
