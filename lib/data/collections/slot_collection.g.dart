// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlotLocalAdapter extends TypeAdapter<SlotLocal> {
  @override
  final typeId = 20;

  @override
  SlotLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlotLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..scheduleRef = fields[2] as String
      ..status = fields[3] as String
      ..startTime = fields[4] as DateTime
      ..endTime = fields[5] as DateTime
      ..serviceType = fields[6] as String?
      ..practitionerRef = fields[7] as String?
      ..organizationRef = fields[8] as String?
      ..maxPatients = (fields[9] as num?)?.toInt()
      ..bookedCount = (fields[10] as num?)?.toInt()
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime?
      ..syncStatus = (fields[13] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, SlotLocal obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.scheduleRef)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.serviceType)
      ..writeByte(7)
      ..write(obj.practitionerRef)
      ..writeByte(8)
      ..write(obj.organizationRef)
      ..writeByte(9)
      ..write(obj.maxPatients)
      ..writeByte(10)
      ..write(obj.bookedCount)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlotLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
