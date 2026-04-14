// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'immunization_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImmunizationLocalAdapter extends TypeAdapter<ImmunizationLocal> {
  @override
  final typeId = 21;

  @override
  ImmunizationLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImmunizationLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..vaccineCode = fields[3] as String
      ..vaccineName = fields[4] as String
      ..occurrenceDate = fields[5] as DateTime
      ..status = fields[6] as String
      ..lotNumber = fields[7] as String?
      ..site = fields[8] as String?
      ..routeOfAdmin = fields[9] as String?
      ..doseQuantity = fields[10] as String?
      ..performerRef = fields[11] as String?
      ..notes = fields[12] as String?
      ..createdAt = fields[13] as DateTime
      ..updatedAt = fields[14] as DateTime?
      ..syncStatus = (fields[15] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, ImmunizationLocal obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.vaccineCode)
      ..writeByte(4)
      ..write(obj.vaccineName)
      ..writeByte(5)
      ..write(obj.occurrenceDate)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.lotNumber)
      ..writeByte(8)
      ..write(obj.site)
      ..writeByte(9)
      ..write(obj.routeOfAdmin)
      ..writeByte(10)
      ..write(obj.doseQuantity)
      ..writeByte(11)
      ..write(obj.performerRef)
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
      other is ImmunizationLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
