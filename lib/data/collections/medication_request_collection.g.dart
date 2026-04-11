// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_request_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationRequestLocalAdapter
    extends TypeAdapter<MedicationRequestLocal> {
  @override
  final typeId = 16;

  @override
  MedicationRequestLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationRequestLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..requesterRef = fields[3] as String
      ..requesterName = fields[4] as String?
      ..medicationCode = fields[5] as String
      ..medicationName = fields[6] as String
      ..status = fields[7] as String
      ..dosageJson = fields[8] as String?
      ..dispenseJson = fields[9] as String?
      ..encounterRef = fields[10] as String?
      ..reasonJson = fields[11] as String?
      ..notes = fields[12] as String?
      ..createdAt = fields[13] as DateTime
      ..updatedAt = fields[14] as DateTime?
      ..syncStatus = (fields[15] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, MedicationRequestLocal obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.requesterRef)
      ..writeByte(4)
      ..write(obj.requesterName)
      ..writeByte(5)
      ..write(obj.medicationCode)
      ..writeByte(6)
      ..write(obj.medicationName)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.dosageJson)
      ..writeByte(9)
      ..write(obj.dispenseJson)
      ..writeByte(10)
      ..write(obj.encounterRef)
      ..writeByte(11)
      ..write(obj.reasonJson)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationRequestLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
