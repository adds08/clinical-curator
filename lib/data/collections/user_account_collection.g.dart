// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAccountAdapter extends TypeAdapter<UserAccount> {
  @override
  final typeId = 0;

  @override
  UserAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAccount()
      ..email = fields[0] as String
      ..passwordHash = fields[1] as String
      ..displayName = fields[2] as String
      ..fhirPatientId = fields[3] as String?
      ..fhirPractitionerId = fields[4] as String?
      ..isPractitioner = fields[5] as bool
      ..isVerified = fields[6] as bool
      ..practitionerType = fields[7] as String?
      ..avatarUrl = fields[8] as String?
      ..healthId = fields[9] as String?
      ..accountType = fields[10] as String
      ..createdAt = fields[11] as DateTime
      ..updatedAt = fields[12] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, UserAccount obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.passwordHash)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.fhirPatientId)
      ..writeByte(4)
      ..write(obj.fhirPractitionerId)
      ..writeByte(5)
      ..write(obj.isPractitioner)
      ..writeByte(6)
      ..write(obj.isVerified)
      ..writeByte(7)
      ..write(obj.practitionerType)
      ..writeByte(8)
      ..write(obj.avatarUrl)
      ..writeByte(9)
      ..write(obj.healthId)
      ..writeByte(10)
      ..write(obj.accountType)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
