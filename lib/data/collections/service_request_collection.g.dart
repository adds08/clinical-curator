// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceRequestLocalAdapter extends TypeAdapter<ServiceRequestLocal> {
  @override
  final typeId = 15;

  @override
  ServiceRequestLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceRequestLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..requesterRef = fields[3] as String
      ..requesterName = fields[4] as String?
      ..code = fields[5] as String
      ..displayName = fields[6] as String
      ..status = fields[7] as String
      ..intent = fields[8] as String
      ..priority = fields[9] as String
      ..category = fields[10] as String?
      ..encounterRef = fields[11] as String?
      ..occurrenceDate = fields[12] as DateTime?
      ..performerRef = fields[13] as String?
      ..reasonJson = fields[14] as String?
      ..notes = fields[15] as String?
      ..createdAt = fields[16] as DateTime
      ..updatedAt = fields[17] as DateTime?
      ..syncStatus = (fields[18] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, ServiceRequestLocal obj) {
    writer
      ..writeByte(19)
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
      ..write(obj.code)
      ..writeByte(6)
      ..write(obj.displayName)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.intent)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.encounterRef)
      ..writeByte(12)
      ..write(obj.occurrenceDate)
      ..writeByte(13)
      ..write(obj.performerRef)
      ..writeByte(14)
      ..write(obj.reasonJson)
      ..writeByte(15)
      ..write(obj.notes)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt)
      ..writeByte(18)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceRequestLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
