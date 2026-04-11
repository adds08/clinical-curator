// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_slot_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleSlotLocalAdapter extends TypeAdapter<ScheduleSlotLocal> {
  @override
  final typeId = 4;

  @override
  ScheduleSlotLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleSlotLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..practitionerRef = fields[1] as String
      ..date = fields[2] as DateTime
      ..startTime = fields[3] as String
      ..endTime = fields[4] as String
      ..slotDurationMinutes = (fields[5] as num).toInt()
      ..maxPatients = (fields[6] as num).toInt()
      ..bookedCount = (fields[7] as num).toInt()
      ..facilityName = fields[8] as String?
      ..isEmergencyOverride = fields[9] as bool
      ..isTelehealth = fields[10] as bool
      ..status = fields[11] as String
      ..createdAt = fields[12] as DateTime
      ..updatedAt = fields[13] as DateTime?
      ..syncStatus = (fields[14] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, ScheduleSlotLocal obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.practitionerRef)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.slotDurationMinutes)
      ..writeByte(6)
      ..write(obj.maxPatients)
      ..writeByte(7)
      ..write(obj.bookedCount)
      ..writeByte(8)
      ..write(obj.facilityName)
      ..writeByte(9)
      ..write(obj.isEmergencyOverride)
      ..writeByte(10)
      ..write(obj.isTelehealth)
      ..writeByte(11)
      ..write(obj.status)
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
      other is ScheduleSlotLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
