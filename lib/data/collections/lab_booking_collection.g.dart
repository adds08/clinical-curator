// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_booking_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabBookingLocalAdapter extends TypeAdapter<LabBookingLocal> {
  @override
  final typeId = 10;

  @override
  LabBookingLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabBookingLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..patientRef = fields[1] as String
      ..testsJson = fields[2] as String
      ..status = fields[3] as String
      ..totalPrice = (fields[4] as num).toDouble()
      ..scheduledAt = fields[5] as DateTime?
      ..labName = fields[6] as String?
      ..notes = fields[7] as String?
      ..createdAt = fields[8] as DateTime
      ..updatedAt = fields[9] as DateTime?
      ..syncStatus = (fields[10] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, LabBookingLocal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientRef)
      ..writeByte(2)
      ..write(obj.testsJson)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.totalPrice)
      ..writeByte(5)
      ..write(obj.scheduledAt)
      ..writeByte(6)
      ..write(obj.labName)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabBookingLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
