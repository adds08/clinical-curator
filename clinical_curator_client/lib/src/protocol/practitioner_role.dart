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

/// Practitioner assignment to an organization with specialty.
abstract class PractitionerRole implements _i1.SerializableModel {
  PractitionerRole._({
    this.id,
    this.fhirId,
    required this.practitionerRef,
    required this.organizationRef,
    required this.code,
    this.specialty,
    this.locationRefsJson,
    this.availableTimeJson,
    required this.active,
    this.practitionerName,
    this.organizationName,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory PractitionerRole({
    int? id,
    String? fhirId,
    required String practitionerRef,
    required String organizationRef,
    required String code,
    String? specialty,
    String? locationRefsJson,
    String? availableTimeJson,
    required bool active,
    String? practitionerName,
    String? organizationName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _PractitionerRoleImpl;

  factory PractitionerRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return PractitionerRole(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      organizationRef: jsonSerialization['organizationRef'] as String,
      code: jsonSerialization['code'] as String,
      specialty: jsonSerialization['specialty'] as String?,
      locationRefsJson: jsonSerialization['locationRefsJson'] as String?,
      availableTimeJson: jsonSerialization['availableTimeJson'] as String?,
      active: _i1.BoolJsonExtension.fromJson(jsonSerialization['active']),
      practitionerName: jsonSerialization['practitionerName'] as String?,
      organizationName: jsonSerialization['organizationName'] as String?,
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

  String practitionerRef;

  String organizationRef;

  String code;

  String? specialty;

  String? locationRefsJson;

  String? availableTimeJson;

  bool active;

  String? practitionerName;

  String? organizationName;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [PractitionerRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PractitionerRole copyWith({
    int? id,
    String? fhirId,
    String? practitionerRef,
    String? organizationRef,
    String? code,
    String? specialty,
    String? locationRefsJson,
    String? availableTimeJson,
    bool? active,
    String? practitionerName,
    String? organizationName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PractitionerRole',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'practitionerRef': practitionerRef,
      'organizationRef': organizationRef,
      'code': code,
      if (specialty != null) 'specialty': specialty,
      if (locationRefsJson != null) 'locationRefsJson': locationRefsJson,
      if (availableTimeJson != null) 'availableTimeJson': availableTimeJson,
      'active': active,
      if (practitionerName != null) 'practitionerName': practitionerName,
      if (organizationName != null) 'organizationName': organizationName,
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

class _PractitionerRoleImpl extends PractitionerRole {
  _PractitionerRoleImpl({
    int? id,
    String? fhirId,
    required String practitionerRef,
    required String organizationRef,
    required String code,
    String? specialty,
    String? locationRefsJson,
    String? availableTimeJson,
    required bool active,
    String? practitionerName,
    String? organizationName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         practitionerRef: practitionerRef,
         organizationRef: organizationRef,
         code: code,
         specialty: specialty,
         locationRefsJson: locationRefsJson,
         availableTimeJson: availableTimeJson,
         active: active,
         practitionerName: practitionerName,
         organizationName: organizationName,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [PractitionerRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PractitionerRole copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? practitionerRef,
    String? organizationRef,
    String? code,
    Object? specialty = _Undefined,
    Object? locationRefsJson = _Undefined,
    Object? availableTimeJson = _Undefined,
    bool? active,
    Object? practitionerName = _Undefined,
    Object? organizationName = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return PractitionerRole(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      organizationRef: organizationRef ?? this.organizationRef,
      code: code ?? this.code,
      specialty: specialty is String? ? specialty : this.specialty,
      locationRefsJson: locationRefsJson is String?
          ? locationRefsJson
          : this.locationRefsJson,
      availableTimeJson: availableTimeJson is String?
          ? availableTimeJson
          : this.availableTimeJson,
      active: active ?? this.active,
      practitionerName: practitionerName is String?
          ? practitionerName
          : this.practitionerName,
      organizationName: organizationName is String?
          ? organizationName
          : this.organizationName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
