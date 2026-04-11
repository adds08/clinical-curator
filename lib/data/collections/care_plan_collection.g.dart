// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_plan_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarePlanLocalAdapter extends TypeAdapter<CarePlanLocal> {
  @override
  final typeId = 14;

  @override
  CarePlanLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarePlanLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..status = fields[3] as String
      ..intent = fields[4] as String
      ..title = fields[5] as String
      ..category = fields[6] as String?
      ..periodStart = fields[7] as DateTime?
      ..periodEnd = fields[8] as DateTime?
      ..activitiesJson = fields[9] as String?
      ..goalsJson = fields[10] as String?
      ..authorRef = fields[11] as String?
      ..encounterRef = fields[12] as String?
      ..notes = fields[13] as String?
      ..createdAt = fields[14] as DateTime
      ..updatedAt = fields[15] as DateTime?
      ..syncStatus = (fields[16] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, CarePlanLocal obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.intent)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.periodStart)
      ..writeByte(8)
      ..write(obj.periodEnd)
      ..writeByte(9)
      ..write(obj.activitiesJson)
      ..writeByte(10)
      ..write(obj.goalsJson)
      ..writeByte(11)
      ..write(obj.authorRef)
      ..writeByte(12)
      ..write(obj.encounterRef)
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
      other is CarePlanLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
