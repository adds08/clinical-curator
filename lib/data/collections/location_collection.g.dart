// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationLocalAdapter extends TypeAdapter<LocationLocal> {
  @override
  final typeId = 17;

  @override
  LocationLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..name = fields[2] as String
      ..type = fields[3] as String
      ..description = fields[4] as String?
      ..address = fields[5] as String?
      ..latitude = (fields[6] as num?)?.toDouble()
      ..longitude = (fields[7] as num?)?.toDouble()
      ..organizationRef = fields[8] as String?
      ..partOfRef = fields[9] as String?
      ..status = fields[10] as String
      ..physicalType = fields[11] as String?
      ..createdAt = fields[12] as DateTime
      ..updatedAt = fields[13] as DateTime?
      ..syncStatus = (fields[14] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, LocationLocal obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.organizationRef)
      ..writeByte(9)
      ..write(obj.partOfRef)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.physicalType)
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
      other is LocationLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
