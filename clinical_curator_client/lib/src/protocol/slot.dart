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

/// Bookable time slot for appointments.
abstract class Slot implements _i1.SerializableModel {
  Slot._({
    this.id,
    this.fhirId,
    required this.scheduleRef,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.serviceType,
    this.practitionerRef,
    this.organizationRef,
    this.maxPatients,
    this.bookedCount,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Slot({
    int? id,
    String? fhirId,
    required String scheduleRef,
    required String status,
    required DateTime startTime,
    required DateTime endTime,
    String? serviceType,
    String? practitionerRef,
    String? organizationRef,
    int? maxPatients,
    int? bookedCount,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _SlotImpl;

  factory Slot.fromJson(Map<String, dynamic> jsonSerialization) {
    return Slot(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      scheduleRef: jsonSerialization['scheduleRef'] as String,
      status: jsonSerialization['status'] as String,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      serviceType: jsonSerialization['serviceType'] as String?,
      practitionerRef: jsonSerialization['practitionerRef'] as String?,
      organizationRef: jsonSerialization['organizationRef'] as String?,
      maxPatients: jsonSerialization['maxPatients'] as int?,
      bookedCount: jsonSerialization['bookedCount'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? fhirId;

  String scheduleRef;

  String status;

  DateTime startTime;

  DateTime endTime;

  String? serviceType;

  String? practitionerRef;

  String? organizationRef;

  int? maxPatients;

  int? bookedCount;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Slot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Slot copyWith({
    int? id,
    String? fhirId,
    String? scheduleRef,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    String? serviceType,
    String? practitionerRef,
    String? organizationRef,
    int? maxPatients,
    int? bookedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Slot',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'scheduleRef': scheduleRef,
      'status': status,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      if (serviceType != null) 'serviceType': serviceType,
      if (practitionerRef != null) 'practitionerRef': practitionerRef,
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (maxPatients != null) 'maxPatients': maxPatients,
      if (bookedCount != null) 'bookedCount': bookedCount,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SlotImpl extends Slot {
  _SlotImpl({
    int? id,
    String? fhirId,
    required String scheduleRef,
    required String status,
    required DateTime startTime,
    required DateTime endTime,
    String? serviceType,
    String? practitionerRef,
    String? organizationRef,
    int? maxPatients,
    int? bookedCount,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         scheduleRef: scheduleRef,
         status: status,
         startTime: startTime,
         endTime: endTime,
         serviceType: serviceType,
         practitionerRef: practitionerRef,
         organizationRef: organizationRef,
         maxPatients: maxPatients,
         bookedCount: bookedCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Slot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Slot copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? scheduleRef,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    Object? serviceType = _Undefined,
    Object? practitionerRef = _Undefined,
    Object? organizationRef = _Undefined,
    Object? maxPatients = _Undefined,
    Object? bookedCount = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Slot(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      scheduleRef: scheduleRef ?? this.scheduleRef,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      serviceType: serviceType is String? ? serviceType : this.serviceType,
      practitionerRef: practitionerRef is String?
          ? practitionerRef
          : this.practitionerRef,
      organizationRef: organizationRef is String?
          ? organizationRef
          : this.organizationRef,
      maxPatients: maxPatients is int? ? maxPatients : this.maxPatients,
      bookedCount: bookedCount is int? ? bookedCount : this.bookedCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
