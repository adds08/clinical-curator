// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentLocalAdapter extends TypeAdapter<PaymentLocal> {
  @override
  final typeId = 25;

  @override
  PaymentLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..fhirId = fields[1] as String?
      ..patientRef = fields[2] as String
      ..amount = (fields[3] as num).toDouble()
      ..currency = fields[4] as String
      ..status = fields[5] as String
      ..method = fields[6] as String
      ..gateway = fields[7] as String?
      ..transactionId = fields[8] as String?
      ..appointmentRef = fields[9] as String?
      ..description = fields[10] as String?
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime?
      ..syncStatus = (fields[13] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, PaymentLocal obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fhirId)
      ..writeByte(2)
      ..write(obj.patientRef)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.method)
      ..writeByte(7)
      ..write(obj.gateway)
      ..writeByte(8)
      ..write(obj.transactionId)
      ..writeByte(9)
      ..write(obj.appointmentRef)
      ..writeByte(10)
      ..write(obj.description)
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
      other is PaymentLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
