// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fhir_resource_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FhirResourceAdapter extends TypeAdapter<FhirResource> {
  @override
  final typeId = 1;

  @override
  FhirResource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FhirResource()
      ..fhirId = fields[0] as String
      ..resourceType = fields[1] as String
      ..jsonData = fields[2] as String
      ..patientReference = fields[3] as String?
      ..practitionerReference = fields[4] as String?
      ..category = fields[5] as String?
      ..syncStatus = (fields[6] as num).toInt()
      ..isDownloadedOffline = fields[7] as bool
      ..lastUpdated = fields[8] as DateTime
      ..createdAt = fields[9] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, FhirResource obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.fhirId)
      ..writeByte(1)
      ..write(obj.resourceType)
      ..writeByte(2)
      ..write(obj.jsonData)
      ..writeByte(3)
      ..write(obj.patientReference)
      ..writeByte(4)
      ..write(obj.practitionerReference)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.isDownloadedOffline)
      ..writeByte(8)
      ..write(obj.lastUpdated)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FhirResourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
