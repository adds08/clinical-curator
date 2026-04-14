// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composition_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompositionLocalAdapter extends TypeAdapter<CompositionLocal> {
  @override
  final typeId = 27;

  @override
  CompositionLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompositionLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..status = fields[2] as String
      ..typeLoincCode = fields[3] as String
      ..typeDisplay = fields[4] as String?
      ..subjectRef = fields[5] as String
      ..encounterRef = fields[6] as String?
      ..dateAuthored = fields[7] as DateTime
      ..authorPractitionerRef = fields[8] as String
      ..authorPractitionerName = fields[9] as String?
      ..title = fields[10] as String
      ..attesterPractitionerRef = fields[11] as String
      ..attesterMode = fields[12] as String
      ..sectionJson = fields[13] as String?
      ..plainText = fields[14] as String?
      ..createdAt = fields[15] as DateTime
      ..syncStatus = (fields[16] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, CompositionLocal obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.typeLoincCode)
      ..writeByte(4)
      ..write(obj.typeDisplay)
      ..writeByte(5)
      ..write(obj.subjectRef)
      ..writeByte(6)
      ..write(obj.encounterRef)
      ..writeByte(7)
      ..write(obj.dateAuthored)
      ..writeByte(8)
      ..write(obj.authorPractitionerRef)
      ..writeByte(9)
      ..write(obj.authorPractitionerName)
      ..writeByte(10)
      ..write(obj.title)
      ..writeByte(11)
      ..write(obj.attesterPractitionerRef)
      ..writeByte(12)
      ..write(obj.attesterMode)
      ..writeByte(13)
      ..write(obj.sectionJson)
      ..writeByte(14)
      ..write(obj.plainText)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositionLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
