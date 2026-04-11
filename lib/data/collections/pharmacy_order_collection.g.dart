// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_order_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PharmacyOrderLocalAdapter extends TypeAdapter<PharmacyOrderLocal> {
  @override
  final typeId = 5;

  @override
  PharmacyOrderLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PharmacyOrderLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..patientRef = fields[1] as String
      ..pharmacyName = fields[2] as String
      ..itemsJson = fields[3] as String
      ..status = fields[4] as String
      ..totalPrice = (fields[5] as num).toDouble()
      ..deliveryAddress = fields[6] as String?
      ..notes = fields[7] as String?
      ..createdAt = fields[8] as DateTime
      ..updatedAt = fields[9] as DateTime?
      ..syncStatus = (fields[10] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, PharmacyOrderLocal obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientRef)
      ..writeByte(2)
      ..write(obj.pharmacyName)
      ..writeByte(3)
      ..write(obj.itemsJson)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.totalPrice)
      ..writeByte(6)
      ..write(obj.deliveryAddress)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PharmacyOrderLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
