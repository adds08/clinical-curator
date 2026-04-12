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

/// Clinical condition or diagnosis.
abstract class Condition implements _i1.SerializableModel {
  Condition._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.code,
    required this.displayName,
    required this.clinicalStatus,
    required this.verificationStatus,
    this.onsetDate,
    this.abatementDate,
    required this.recordedDate,
    this.severity,
    this.bodySite,
    this.encounterRef,
    this.recorderRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Condition({
    int? id,
    String? fhirId,
    required String patientRef,
    required String code,
    required String displayName,
    required String clinicalStatus,
    required String verificationStatus,
    DateTime? onsetDate,
    DateTime? abatementDate,
    required DateTime recordedDate,
    String? severity,
    String? bodySite,
    String? encounterRef,
    String? recorderRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ConditionImpl;

  factory Condition.fromJson(Map<String, dynamic> jsonSerialization) {
    return Condition(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      clinicalStatus: jsonSerialization['clinicalStatus'] as String,
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      onsetDate: jsonSerialization['onsetDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['onsetDate']),
      abatementDate: jsonSerialization['abatementDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['abatementDate'],
            ),
      recordedDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['recordedDate'],
      ),
      severity: jsonSerialization['severity'] as String?,
      bodySite: jsonSerialization['bodySite'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      recorderRef: jsonSerialization['recorderRef'] as String?,
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

  String code;

  String displayName;

  String clinicalStatus;

  String verificationStatus;

  DateTime? onsetDate;

  DateTime? abatementDate;

  DateTime recordedDate;

  String? severity;

  String? bodySite;

  String? encounterRef;

  String? recorderRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Condition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Condition copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? code,
    String? displayName,
    String? clinicalStatus,
    String? verificationStatus,
    DateTime? onsetDate,
    DateTime? abatementDate,
    DateTime? recordedDate,
    String? severity,
    String? bodySite,
    String? encounterRef,
    String? recorderRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Condition',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'code': code,
      'displayName': displayName,
      'clinicalStatus': clinicalStatus,
      'verificationStatus': verificationStatus,
      if (onsetDate != null) 'onsetDate': onsetDate?.toJson(),
      if (abatementDate != null) 'abatementDate': abatementDate?.toJson(),
      'recordedDate': recordedDate.toJson(),
      if (severity != null) 'severity': severity,
      if (bodySite != null) 'bodySite': bodySite,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (recorderRef != null) 'recorderRef': recorderRef,
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

class _ConditionImpl extends Condition {
  _ConditionImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String code,
    required String displayName,
    required String clinicalStatus,
    required String verificationStatus,
    DateTime? onsetDate,
    DateTime? abatementDate,
    required DateTime recordedDate,
    String? severity,
    String? bodySite,
    String? encounterRef,
    String? recorderRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         code: code,
         displayName: displayName,
         clinicalStatus: clinicalStatus,
         verificationStatus: verificationStatus,
         onsetDate: onsetDate,
         abatementDate: abatementDate,
         recordedDate: recordedDate,
         severity: severity,
         bodySite: bodySite,
         encounterRef: encounterRef,
         recorderRef: recorderRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Condition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Condition copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? code,
    String? displayName,
    String? clinicalStatus,
    String? verificationStatus,
    Object? onsetDate = _Undefined,
    Object? abatementDate = _Undefined,
    DateTime? recordedDate,
    Object? severity = _Undefined,
    Object? bodySite = _Undefined,
    Object? encounterRef = _Undefined,
    Object? recorderRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Condition(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      clinicalStatus: clinicalStatus ?? this.clinicalStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      onsetDate: onsetDate is DateTime? ? onsetDate : this.onsetDate,
      abatementDate: abatementDate is DateTime?
          ? abatementDate
          : this.abatementDate,
      recordedDate: recordedDate ?? this.recordedDate,
      severity: severity is String? ? severity : this.severity,
      bodySite: bodySite is String? ? bodySite : this.bodySite,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      recorderRef: recorderRef is String? ? recorderRef : this.recorderRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
