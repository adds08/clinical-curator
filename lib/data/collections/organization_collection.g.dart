// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationLocalAdapter extends TypeAdapter<OrganizationLocal> {
  @override
  final typeId = 9;

  @override
  OrganizationLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..name = fields[2] as String
      ..type = fields[3] as String
      ..address = fields[4] as String
      ..phone = fields[5] as String?
      ..latitude = (fields[6] as num?)?.toDouble()
      ..longitude = (fields[7] as num?)?.toDouble()
      ..openHours = fields[8] as String?
      ..rating = (fields[9] as num?)?.toDouble()
      ..hasEmergency = fields[10] as bool
      ..isOpen24Hours = fields[11] as bool
      ..departmentsJson = fields[12] as String?
      ..servicesJson = fields[13] as String?
      ..createdAt = fields[14] as DateTime
      ..syncStatus = (fields[15] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, OrganizationLocal obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.openHours)
      ..writeByte(9)
      ..write(obj.rating)
      ..writeByte(10)
      ..write(obj.hasEmergency)
      ..writeByte(11)
      ..write(obj.isOpen24Hours)
      ..writeByte(12)
      ..write(obj.departmentsJson)
      ..writeByte(13)
      ..write(obj.servicesJson)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
