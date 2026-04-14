// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentLocalAdapter extends TypeAdapter<AppointmentLocal> {
  @override
  final typeId = 3;

  @override
  AppointmentLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..practitionerRef = fields[3] as String
      ..practitionerName = fields[4] as String
      ..patientName = fields[5] as String
      ..appointmentType = fields[6] as String
      ..status = fields[7] as String
      ..scheduledAt = fields[8] as DateTime
      ..durationMinutes = (fields[9] as num).toInt()
      ..specialty = fields[10] as String?
      ..notes = fields[11] as String?
      ..createdAt = fields[12] as DateTime
      ..updatedAt = fields[13] as DateTime?
      ..syncStatus = (fields[14] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, AppointmentLocal obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.practitionerRef)
      ..writeByte(4)
      ..write(obj.practitionerName)
      ..writeByte(5)
      ..write(obj.patientName)
      ..writeByte(6)
      ..write(obj.appointmentType)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.scheduledAt)
      ..writeByte(9)
      ..write(obj.durationMinutes)
      ..writeByte(10)
      ..write(obj.specialty)
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
      other is AppointmentLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
