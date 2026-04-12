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

/// Clinical procedure performed on a patient.
abstract class Procedure implements _i1.SerializableModel {
  Procedure._({
    this.id,
    this.fhirId,
    required this.patientRef,
    this.encounterRef,
    required this.code,
    required this.displayName,
    required this.status,
    this.performedDate,
    this.performerRef,
    this.performerName,
    this.bodySite,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Procedure({
    int? id,
    String? fhirId,
    required String patientRef,
    String? encounterRef,
    required String code,
    required String displayName,
    required String status,
    DateTime? performedDate,
    String? performerRef,
    String? performerName,
    String? bodySite,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ProcedureImpl;

  factory Procedure.fromJson(Map<String, dynamic> jsonSerialization) {
    return Procedure(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      status: jsonSerialization['status'] as String,
      performedDate: jsonSerialization['performedDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['performedDate'],
            ),
      performerRef: jsonSerialization['performerRef'] as String?,
      performerName: jsonSerialization['performerName'] as String?,
      bodySite: jsonSerialization['bodySite'] as String?,
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

  String? encounterRef;

  String code;

  String displayName;

  String status;

  DateTime? performedDate;

  String? performerRef;

  String? performerName;

  String? bodySite;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Procedure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Procedure copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? encounterRef,
    String? code,
    String? displayName,
    String? status,
    DateTime? performedDate,
    String? performerRef,
    String? performerName,
    String? bodySite,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Procedure',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      if (encounterRef != null) 'encounterRef': encounterRef,
      'code': code,
      'displayName': displayName,
      'status': status,
      if (performedDate != null) 'performedDate': performedDate?.toJson(),
      if (performerRef != null) 'performerRef': performerRef,
      if (performerName != null) 'performerName': performerName,
      if (bodySite != null) 'bodySite': bodySite,
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

class _ProcedureImpl extends Procedure {
  _ProcedureImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    String? encounterRef,
    required String code,
    required String displayName,
    required String status,
    DateTime? performedDate,
    String? performerRef,
    String? performerName,
    String? bodySite,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         encounterRef: encounterRef,
         code: code,
         displayName: displayName,
         status: status,
         performedDate: performedDate,
         performerRef: performerRef,
         performerName: performerName,
         bodySite: bodySite,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Procedure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Procedure copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    Object? encounterRef = _Undefined,
    String? code,
    String? displayName,
    String? status,
    Object? performedDate = _Undefined,
    Object? performerRef = _Undefined,
    Object? performerName = _Undefined,
    Object? bodySite = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Procedure(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      performedDate: performedDate is DateTime?
          ? performedDate
          : this.performedDate,
      performerRef: performerRef is String? ? performerRef : this.performerRef,
      performerName: performerName is String?
          ? performerName
          : this.performerName,
      bodySite: bodySite is String? ? bodySite : this.bodySite,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
