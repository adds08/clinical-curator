// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_claim_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsuranceClaimLocalAdapter extends TypeAdapter<InsuranceClaimLocal> {
  @override
  final typeId = 6;

  @override
  InsuranceClaimLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsuranceClaimLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..patientRef = fields[1] as String
      ..claimType = fields[2] as String
      ..provider = fields[3] as String
      ..policyNumber = fields[4] as String
      ..amount = (fields[5] as num).toDouble()
      ..status = fields[6] as String
      ..description = fields[7] as String?
      ..documentsJson = fields[8] as String?
      ..createdAt = fields[9] as DateTime
      ..updatedAt = fields[10] as DateTime?
      ..syncStatus = (fields[11] as num).toInt();
  }

  @override
  void write(BinaryWriter writer, InsuranceClaimLocal obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientRef)
      ..writeByte(2)
      ..write(obj.claimType)
      ..writeByte(3)
      ..write(obj.provider)
      ..writeByte(4)
      ..write(obj.policyNumber)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.documentsJson)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsuranceClaimLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
