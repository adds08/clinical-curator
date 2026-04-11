// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_record_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationRecordLocalAdapter
    extends TypeAdapter<NotificationRecordLocal> {
  @override
  final typeId = 7;

  @override
  NotificationRecordLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationRecordLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..userEmail = fields[1] as String
      ..title = fields[2] as String
      ..body = fields[3] as String
      ..type = fields[4] as String
      ..isRead = fields[5] as bool
      ..relatedResourceId = fields[6] as String?
      ..relatedRoute = fields[7] as String?
      ..createdAt = fields[8] as DateTime
      ..syncStatus = (fields[9] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, NotificationRecordLocal obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userEmail)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.relatedResourceId)
      ..writeByte(7)
      ..write(obj.relatedRoute)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationRecordLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
