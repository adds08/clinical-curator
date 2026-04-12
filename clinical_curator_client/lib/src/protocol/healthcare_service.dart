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

/// Healthcare service offered by an organization.
abstract class HealthcareService implements _i1.SerializableModel {
  HealthcareService._({
    this.id,
    this.fhirId,
    required this.organizationRef,
    required this.name,
    required this.type,
    this.specialty,
    this.availableTimeJson,
    this.locationRef,
    required this.active,
    this.comment,
    this.telecom,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory HealthcareService({
    int? id,
    String? fhirId,
    required String organizationRef,
    required String name,
    required String type,
    String? specialty,
    String? availableTimeJson,
    String? locationRef,
    required bool active,
    String? comment,
    String? telecom,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _HealthcareServiceImpl;

  factory HealthcareService.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthcareService(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      organizationRef: jsonSerialization['organizationRef'] as String,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      specialty: jsonSerialization['specialty'] as String?,
      availableTimeJson: jsonSerialization['availableTimeJson'] as String?,
      locationRef: jsonSerialization['locationRef'] as String?,
      active: _i1.BoolJsonExtension.fromJson(jsonSerialization['active']),
      comment: jsonSerialization['comment'] as String?,
      telecom: jsonSerialization['telecom'] as String?,
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

  String organizationRef;

  String name;

  String type;

  String? specialty;

  String? availableTimeJson;

  String? locationRef;

  bool active;

  String? comment;

  String? telecom;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [HealthcareService]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HealthcareService copyWith({
    int? id,
    String? fhirId,
    String? organizationRef,
    String? name,
    String? type,
    String? specialty,
    String? availableTimeJson,
    String? locationRef,
    bool? active,
    String? comment,
    String? telecom,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthcareService',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'organizationRef': organizationRef,
      'name': name,
      'type': type,
      if (specialty != null) 'specialty': specialty,
      if (availableTimeJson != null) 'availableTimeJson': availableTimeJson,
      if (locationRef != null) 'locationRef': locationRef,
      'active': active,
      if (comment != null) 'comment': comment,
      if (telecom != null) 'telecom': telecom,
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

class _HealthcareServiceImpl extends HealthcareService {
  _HealthcareServiceImpl({
    int? id,
    String? fhirId,
    required String organizationRef,
    required String name,
    required String type,
    String? specialty,
    String? availableTimeJson,
    String? locationRef,
    required bool active,
    String? comment,
    String? telecom,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         organizationRef: organizationRef,
         name: name,
         type: type,
         specialty: specialty,
         availableTimeJson: availableTimeJson,
         locationRef: locationRef,
         active: active,
         comment: comment,
         telecom: telecom,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [HealthcareService]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HealthcareService copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? organizationRef,
    String? name,
    String? type,
    Object? specialty = _Undefined,
    Object? availableTimeJson = _Undefined,
    Object? locationRef = _Undefined,
    bool? active,
    Object? comment = _Undefined,
    Object? telecom = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return HealthcareService(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      organizationRef: organizationRef ?? this.organizationRef,
      name: name ?? this.name,
      type: type ?? this.type,
      specialty: specialty is String? ? specialty : this.specialty,
      availableTimeJson: availableTimeJson is String?
          ? availableTimeJson
          : this.availableTimeJson,
      locationRef: locationRef is String? ? locationRef : this.locationRef,
      active: active ?? this.active,
      comment: comment is String? ? comment : this.comment,
      telecom: telecom is String? ? telecom : this.telecom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
