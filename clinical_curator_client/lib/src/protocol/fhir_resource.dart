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

/// Stores FHIR R4 resources as JSON with denormalized index fields.
abstract class FhirResourceRecord implements _i1.SerializableModel {
  FhirResourceRecord._({
    this.id,
    required this.fhirId,
    required this.resourceType,
    required this.jsonData,
    this.patientReference,
    this.practitionerReference,
    this.category,
    required this.syncVersion,
    required this.lastUpdated,
    required this.createdAt,
  });

  factory FhirResourceRecord({
    int? id,
    required String fhirId,
    required String resourceType,
    required String jsonData,
    String? patientReference,
    String? practitionerReference,
    String? category,
    required int syncVersion,
    required DateTime lastUpdated,
    required DateTime createdAt,
  }) = _FhirResourceRecordImpl;

  factory FhirResourceRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return FhirResourceRecord(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String,
      resourceType: jsonSerialization['resourceType'] as String,
      jsonData: jsonSerialization['jsonData'] as String,
      patientReference: jsonSerialization['patientReference'] as String?,
      practitionerReference:
          jsonSerialization['practitionerReference'] as String?,
      category: jsonSerialization['category'] as String?,
      syncVersion: jsonSerialization['syncVersion'] as int,
      lastUpdated: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUpdated'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String fhirId;

  String resourceType;

  String jsonData;

  String? patientReference;

  String? practitionerReference;

  String? category;

  int syncVersion;

  DateTime lastUpdated;

  DateTime createdAt;

  /// Returns a shallow copy of this [FhirResourceRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FhirResourceRecord copyWith({
    int? id,
    String? fhirId,
    String? resourceType,
    String? jsonData,
    String? patientReference,
    String? practitionerReference,
    String? category,
    int? syncVersion,
    DateTime? lastUpdated,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FhirResourceRecord',
      if (id != null) 'id': id,
      'fhirId': fhirId,
      'resourceType': resourceType,
      'jsonData': jsonData,
      if (patientReference != null) 'patientReference': patientReference,
      if (practitionerReference != null)
        'practitionerReference': practitionerReference,
      if (category != null) 'category': category,
      'syncVersion': syncVersion,
      'lastUpdated': lastUpdated.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FhirResourceRecordImpl extends FhirResourceRecord {
  _FhirResourceRecordImpl({
    int? id,
    required String fhirId,
    required String resourceType,
    required String jsonData,
    String? patientReference,
    String? practitionerReference,
    String? category,
    required int syncVersion,
    required DateTime lastUpdated,
    required DateTime createdAt,
  }) : super._(
         id: id,
         fhirId: fhirId,
         resourceType: resourceType,
         jsonData: jsonData,
         patientReference: patientReference,
         practitionerReference: practitionerReference,
         category: category,
         syncVersion: syncVersion,
         lastUpdated: lastUpdated,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FhirResourceRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FhirResourceRecord copyWith({
    Object? id = _Undefined,
    String? fhirId,
    String? resourceType,
    String? jsonData,
    Object? patientReference = _Undefined,
    Object? practitionerReference = _Undefined,
    Object? category = _Undefined,
    int? syncVersion,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return FhirResourceRecord(
      id: id is int? ? id : this.id,
      fhirId: fhirId ?? this.fhirId,
      resourceType: resourceType ?? this.resourceType,
      jsonData: jsonData ?? this.jsonData,
      patientReference: patientReference is String?
          ? patientReference
          : this.patientReference,
      practitionerReference: practitionerReference is String?
          ? practitionerReference
          : this.practitionerReference,
      category: category is String? ? category : this.category,
      syncVersion: syncVersion ?? this.syncVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
