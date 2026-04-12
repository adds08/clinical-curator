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

/// Clinical encounter (visit, admission, or emergency).
abstract class Encounter implements _i1.SerializableModel {
  Encounter._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.practitionerRef,
    required this.status,
    required this.classCode,
    required this.startDate,
    this.endDate,
    this.organizationRef,
    this.reasonJson,
    this.serviceType,
    this.notes,
    this.patientName,
    this.practitionerName,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Encounter({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String status,
    required String classCode,
    required DateTime startDate,
    DateTime? endDate,
    String? organizationRef,
    String? reasonJson,
    String? serviceType,
    String? notes,
    String? patientName,
    String? practitionerName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _EncounterImpl;

  factory Encounter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Encounter(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      status: jsonSerialization['status'] as String,
      classCode: jsonSerialization['classCode'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      organizationRef: jsonSerialization['organizationRef'] as String?,
      reasonJson: jsonSerialization['reasonJson'] as String?,
      serviceType: jsonSerialization['serviceType'] as String?,
      notes: jsonSerialization['notes'] as String?,
      patientName: jsonSerialization['patientName'] as String?,
      practitionerName: jsonSerialization['practitionerName'] as String?,
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

  String patientRef;

  String practitionerRef;

  String status;

  String classCode;

  DateTime startDate;

  DateTime? endDate;

  String? organizationRef;

  String? reasonJson;

  String? serviceType;

  String? notes;

  String? patientName;

  String? practitionerName;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Encounter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Encounter copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? practitionerRef,
    String? status,
    String? classCode,
    DateTime? startDate,
    DateTime? endDate,
    String? organizationRef,
    String? reasonJson,
    String? serviceType,
    String? notes,
    String? patientName,
    String? practitionerName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Encounter',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'practitionerRef': practitionerRef,
      'status': status,
      'classCode': classCode,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (serviceType != null) 'serviceType': serviceType,
      if (notes != null) 'notes': notes,
      if (patientName != null) 'patientName': patientName,
      if (practitionerName != null) 'practitionerName': practitionerName,
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

class _EncounterImpl extends Encounter {
  _EncounterImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String status,
    required String classCode,
    required DateTime startDate,
    DateTime? endDate,
    String? organizationRef,
    String? reasonJson,
    String? serviceType,
    String? notes,
    String? patientName,
    String? practitionerName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         practitionerRef: practitionerRef,
         status: status,
         classCode: classCode,
         startDate: startDate,
         endDate: endDate,
         organizationRef: organizationRef,
         reasonJson: reasonJson,
         serviceType: serviceType,
         notes: notes,
         patientName: patientName,
         practitionerName: practitionerName,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Encounter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Encounter copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? practitionerRef,
    String? status,
    String? classCode,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? organizationRef = _Undefined,
    Object? reasonJson = _Undefined,
    Object? serviceType = _Undefined,
    Object? notes = _Undefined,
    Object? patientName = _Undefined,
    Object? practitionerName = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Encounter(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      status: status ?? this.status,
      classCode: classCode ?? this.classCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      organizationRef: organizationRef is String?
          ? organizationRef
          : this.organizationRef,
      reasonJson: reasonJson is String? ? reasonJson : this.reasonJson,
      serviceType: serviceType is String? ? serviceType : this.serviceType,
      notes: notes is String? ? notes : this.notes,
      patientName: patientName is String? ? patientName : this.patientName,
      practitionerName: practitionerName is String?
          ? practitionerName
          : this.practitionerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
