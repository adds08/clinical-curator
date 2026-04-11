// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'healthcare_service_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthcareServiceLocalAdapter
    extends TypeAdapter<HealthcareServiceLocal> {
  @override
  final typeId = 18;

  @override
  HealthcareServiceLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthcareServiceLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..organizationRef = fields[2] as String
      ..name = fields[3] as String
      ..type = fields[4] as String
      ..specialty = fields[5] as String?
      ..availableTimeJson = fields[6] as String?
      ..locationRef = fields[7] as String?
      ..active = fields[8] as bool
      ..comment = fields[9] as String?
      ..telecom = fields[10] as String?
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime?
      ..syncStatus = (fields[13] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, HealthcareServiceLocal obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.organizationRef)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.specialty)
      ..writeByte(6)
      ..write(obj.availableTimeJson)
      ..writeByte(7)
      ..write(obj.locationRef)
      ..writeByte(8)
      ..write(obj.active)
      ..writeByte(9)
      ..write(obj.comment)
      ..writeByte(10)
      ..write(obj.telecom)
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
      other is HealthcareServiceLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
