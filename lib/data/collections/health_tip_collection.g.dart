// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_tip_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthTipLocalAdapter extends TypeAdapter<HealthTipLocal> {
  @override
  final typeId = 8;

  @override
  HealthTipLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthTipLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..title = fields[1] as String
      ..summary = fields[2] as String
      ..content = fields[3] as String
      ..category = fields[4] as String
      ..imageUrl = fields[5] as String?
      ..author = fields[6] as String
      ..isActive = fields[7] as bool
      ..publishedAt = fields[8] as DateTime
      ..createdAt = fields[9] as DateTime
      ..syncStatus = (fields[10] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, HealthTipLocal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.author)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.publishedAt)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthTipLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
