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

/// Medication prescription.
abstract class MedicationRequest implements _i1.SerializableModel {
  MedicationRequest._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.requesterRef,
    this.requesterName,
    required this.medicationCode,
    required this.medicationName,
    required this.status,
    this.dosageJson,
    this.dispenseJson,
    this.encounterRef,
    this.reasonJson,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory MedicationRequest({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String medicationCode,
    required String medicationName,
    required String status,
    String? dosageJson,
    String? dispenseJson,
    String? encounterRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _MedicationRequestImpl;

  factory MedicationRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return MedicationRequest(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      requesterRef: jsonSerialization['requesterRef'] as String,
      requesterName: jsonSerialization['requesterName'] as String?,
      medicationCode: jsonSerialization['medicationCode'] as String,
      medicationName: jsonSerialization['medicationName'] as String,
      status: jsonSerialization['status'] as String,
      dosageJson: jsonSerialization['dosageJson'] as String?,
      dispenseJson: jsonSerialization['dispenseJson'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      reasonJson: jsonSerialization['reasonJson'] as String?,
      notes: jsonSerialization['notes'] as String?,
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

  String requesterRef;

  String? requesterName;

  String medicationCode;

  String medicationName;

  String status;

  String? dosageJson;

  String? dispenseJson;

  String? encounterRef;

  String? reasonJson;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [MedicationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MedicationRequest copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? requesterRef,
    String? requesterName,
    String? medicationCode,
    String? medicationName,
    String? status,
    String? dosageJson,
    String? dispenseJson,
    String? encounterRef,
    String? reasonJson,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MedicationRequest',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'requesterRef': requesterRef,
      if (requesterName != null) 'requesterName': requesterName,
      'medicationCode': medicationCode,
      'medicationName': medicationName,
      'status': status,
      if (dosageJson != null) 'dosageJson': dosageJson,
      if (dispenseJson != null) 'dispenseJson': dispenseJson,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (notes != null) 'notes': notes,
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

class _MedicationRequestImpl extends MedicationRequest {
  _MedicationRequestImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String medicationCode,
    required String medicationName,
    required String status,
    String? dosageJson,
    String? dispenseJson,
    String? encounterRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         requesterRef: requesterRef,
         requesterName: requesterName,
         medicationCode: medicationCode,
         medicationName: medicationName,
         status: status,
         dosageJson: dosageJson,
         dispenseJson: dispenseJson,
         encounterRef: encounterRef,
         reasonJson: reasonJson,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [MedicationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MedicationRequest copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? requesterRef,
    Object? requesterName = _Undefined,
    String? medicationCode,
    String? medicationName,
    String? status,
    Object? dosageJson = _Undefined,
    Object? dispenseJson = _Undefined,
    Object? encounterRef = _Undefined,
    Object? reasonJson = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return MedicationRequest(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      requesterRef: requesterRef ?? this.requesterRef,
      requesterName: requesterName is String?
          ? requesterName
          : this.requesterName,
      medicationCode: medicationCode ?? this.medicationCode,
      medicationName: medicationName ?? this.medicationName,
      status: status ?? this.status,
      dosageJson: dosageJson is String? ? dosageJson : this.dosageJson,
      dispenseJson: dispenseJson is String? ? dispenseJson : this.dispenseJson,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      reasonJson: reasonJson is String? ? reasonJson : this.reasonJson,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
