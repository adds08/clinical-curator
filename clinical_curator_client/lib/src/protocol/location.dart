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

/// Physical location within a facility.
abstract class Location implements _i1.SerializableModel {
  Location._({
    this.id,
    this.fhirId,
    required this.name,
    required this.type,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.organizationRef,
    this.partOfRef,
    required this.status,
    this.physicalType,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Location({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? organizationRef,
    String? partOfRef,
    required String status,
    String? physicalType,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _LocationImpl;

  factory Location.fromJson(Map<String, dynamic> jsonSerialization) {
    return Location(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String?,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      organizationRef: jsonSerialization['organizationRef'] as String?,
      partOfRef: jsonSerialization['partOfRef'] as String?,
      status: jsonSerialization['status'] as String,
      physicalType: jsonSerialization['physicalType'] as String?,
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

  String name;

  String type;

  String? description;

  String? address;

  double? latitude;

  double? longitude;

  String? organizationRef;

  String? partOfRef;

  String status;

  String? physicalType;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Location copyWith({
    int? id,
    String? fhirId,
    String? name,
    String? type,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? organizationRef,
    String? partOfRef,
    String? status,
    String? physicalType,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (partOfRef != null) 'partOfRef': partOfRef,
      'status': status,
      if (physicalType != null) 'physicalType': physicalType,
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

class _LocationImpl extends Location {
  _LocationImpl({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? organizationRef,
    String? partOfRef,
    required String status,
    String? physicalType,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         name: name,
         type: type,
         description: description,
         address: address,
         latitude: latitude,
         longitude: longitude,
         organizationRef: organizationRef,
         partOfRef: partOfRef,
         status: status,
         physicalType: physicalType,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Location copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? name,
    String? type,
    Object? description = _Undefined,
    Object? address = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? organizationRef = _Undefined,
    Object? partOfRef = _Undefined,
    String? status,
    Object? physicalType = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Location(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description is String? ? description : this.description,
      address: address is String? ? address : this.address,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      organizationRef: organizationRef is String?
          ? organizationRef
          : this.organizationRef,
      partOfRef: partOfRef is String? ? partOfRef : this.partOfRef,
      status: status ?? this.status,
      physicalType: physicalType is String? ? physicalType : this.physicalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
