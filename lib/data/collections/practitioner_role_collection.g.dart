// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practitioner_role_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PractitionerRoleLocalAdapter extends TypeAdapter<PractitionerRoleLocal> {
  @override
  final typeId = 19;

  @override
  PractitionerRoleLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PractitionerRoleLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..practitionerRef = fields[2] as String
      ..organizationRef = fields[3] as String
      ..code = fields[4] as String
      ..specialty = fields[5] as String?
      ..locationRefsJson = fields[6] as String?
      ..availableTimeJson = fields[7] as String?
      ..active = fields[8] as bool
      ..practitionerName = fields[9] as String?
      ..organizationName = fields[10] as String?
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime?
      ..syncStatus = (fields[13] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, PractitionerRoleLocal obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.practitionerRef)
      ..writeByte(3)
      ..write(obj.organizationRef)
      ..writeByte(4)
      ..write(obj.code)
      ..writeByte(5)
      ..write(obj.specialty)
      ..writeByte(6)
      ..write(obj.locationRefsJson)
      ..writeByte(7)
      ..write(obj.availableTimeJson)
      ..writeByte(8)
      ..write(obj.active)
      ..writeByte(9)
      ..write(obj.practitionerName)
      ..writeByte(10)
      ..write(obj.organizationName)
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
      other is PractitionerRoleLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
