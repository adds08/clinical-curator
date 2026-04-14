// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambulance_request_collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmbulanceRequestLocalAdapter extends TypeAdapter<AmbulanceRequestLocal> {
  @override
  final typeId = 2;

  @override
  AmbulanceRequestLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmbulanceRequestLocal()
      ..id = (fields[0] as num?)?.toInt()
      ..patientRef = fields[1] as String
      ..patientName = fields[2] as String
      ..contactNumber = fields[3] as String
      ..emergencyType = fields[4] as String
      ..pickupLocation = fields[5] as String
      ..status = fields[6] as String
      ..latitude = (fields[7] as num?)?.toDouble()
      ..longitude = (fields[8] as num?)?.toDouble()
      ..assignedDriverName = fields[9] as String?
      ..assignedVehicleNumber = fields[10] as String?
      ..estimatedArrivalMinutes = (fields[11] as num?)?.toInt()
      ..notes = fields[12] as String?
      ..createdAt = fields[13] as DateTime
      ..updatedAt = fields[14] as DateTime?
      ..syncStatus = (fields[15] as num).toInt()
      ..cancellationReason = fields[16] as String?
      ..timelinessRating = fields[17] as String?
      ..helpfulnessRating = (fields[18] as num?)?.toInt()
      ..feedbackNotes = fields[19] as String?;
  }

  @override
  void write(BinaryWriter writer, AmbulanceRequestLocal obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patientRef)
      ..writeByte(2)
      ..write(obj.patientName)
      ..writeByte(3)
      ..write(obj.contactNumber)
      ..writeByte(4)
      ..write(obj.emergencyType)
      ..writeByte(5)
      ..write(obj.pickupLocation)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.assignedDriverName)
      ..writeByte(10)
      ..write(obj.assignedVehicleNumber)
      ..writeByte(11)
      ..write(obj.estimatedArrivalMinutes)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.syncStatus)
      ..writeByte(16)
      ..write(obj.cancellationReason)
      ..writeByte(17)
      ..write(obj.timelinessRating)
      ..writeByte(18)
      ..write(obj.helpfulnessRating)
      ..writeByte(19)
      ..write(obj.feedbackNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmbulanceRequestLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
