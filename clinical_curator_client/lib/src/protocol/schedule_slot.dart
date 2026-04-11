/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Doctor availability schedule slot.
abstract class ScheduleSlot implements _i1.SerializableModel {
  ScheduleSlot._({
    this.id,
    required this.practitionerRef,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.slotDurationMinutes,
    required this.maxPatients,
    required this.bookedCount,
    this.facilityName,
    required this.isEmergencyOverride,
    required this.isTelehealth,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory ScheduleSlot({
    int? id,
    required String practitionerRef,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int slotDurationMinutes,
    required int maxPatients,
    required int bookedCount,
    String? facilityName,
    required bool isEmergencyOverride,
    required bool isTelehealth,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ScheduleSlotImpl;

  factory ScheduleSlot.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduleSlot(
      id: jsonSerialization['id'] as int?,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      slotDurationMinutes: jsonSerialization['slotDurationMinutes'] as int,
      maxPatients: jsonSerialization['maxPatients'] as int,
      bookedCount: jsonSerialization['bookedCount'] as int,
      facilityName: jsonSerialization['facilityName'] as String?,
      isEmergencyOverride: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isEmergencyOverride'],
      ),
      isTelehealth: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isTelehealth'],
      ),
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String practitionerRef;

  DateTime date;

  String startTime;

  String endTime;

  int slotDurationMinutes;

  int maxPatients;

  int bookedCount;

  String? facilityName;

  bool isEmergencyOverride;

  bool isTelehealth;

  String status;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ScheduleSlot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScheduleSlot copyWith({
    int? id,
    String? practitionerRef,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? slotDurationMinutes,
    int? maxPatients,
    int? bookedCount,
    String? facilityName,
    bool? isEmergencyOverride,
    bool? isTelehealth,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduleSlot',
      if (id != null) 'id': id,
      'practitionerRef': practitionerRef,
      'date': date.toJson(),
      'startTime': startTime,
      'endTime': endTime,
      'slotDurationMinutes': slotDurationMinutes,
      'maxPatients': maxPatients,
      'bookedCount': bookedCount,
      if (facilityName != null) 'facilityName': facilityName,
      'isEmergencyOverride': isEmergencyOverride,
      'isTelehealth': isTelehealth,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduleSlotImpl extends ScheduleSlot {
  _ScheduleSlotImpl({
    int? id,
    required String practitionerRef,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int slotDurationMinutes,
    required int maxPatients,
    required int bookedCount,
    String? facilityName,
    required bool isEmergencyOverride,
    required bool isTelehealth,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         practitionerRef: practitionerRef,
         date: date,
         startTime: startTime,
         endTime: endTime,
         slotDurationMinutes: slotDurationMinutes,
         maxPatients: maxPatients,
         bookedCount: bookedCount,
         facilityName: facilityName,
         isEmergencyOverride: isEmergencyOverride,
         isTelehealth: isTelehealth,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ScheduleSlot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScheduleSlot copyWith({
    Object? id = _Undefined,
    String? practitionerRef,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? slotDurationMinutes,
    int? maxPatients,
    int? bookedCount,
    Object? facilityName = _Undefined,
    bool? isEmergencyOverride,
    bool? isTelehealth,
    String? status,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return ScheduleSlot(
      id: id is int? ? id : this.id,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      maxPatients: maxPatients ?? this.maxPatients,
      bookedCount: bookedCount ?? this.bookedCount,
      facilityName: facilityName is String? ? facilityName : this.facilityName,
      isEmergencyOverride: isEmergencyOverride ?? this.isEmergencyOverride,
      isTelehealth: isTelehealth ?? this.isTelehealth,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
