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

/// Hospital, pharmacy, or facility (maps to FHIR Organization/Location).
abstract class Organization implements _i1.SerializableModel {
  Organization._({
    this.id,
    this.fhirId,
    required this.name,
    required this.type,
    required this.address,
    this.phone,
    this.latitude,
    this.longitude,
    this.openHours,
    this.rating,
    required this.hasEmergency,
    required this.isOpen24Hours,
    this.departmentsJson,
    this.servicesJson,
    required this.createdAt,
  });

  factory Organization({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    required String address,
    String? phone,
    double? latitude,
    double? longitude,
    String? openHours,
    double? rating,
    required bool hasEmergency,
    required bool isOpen24Hours,
    String? departmentsJson,
    String? servicesJson,
    required DateTime createdAt,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      address: jsonSerialization['address'] as String,
      phone: jsonSerialization['phone'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      openHours: jsonSerialization['openHours'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      hasEmergency: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hasEmergency'],
      ),
      isOpen24Hours: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isOpen24Hours'],
      ),
      departmentsJson: jsonSerialization['departmentsJson'] as String?,
      servicesJson: jsonSerialization['servicesJson'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? fhirId;

  String name;

  String type;

  String address;

  String? phone;

  double? latitude;

  double? longitude;

  String? openHours;

  double? rating;

  bool hasEmergency;

  bool isOpen24Hours;

  String? departmentsJson;

  String? servicesJson;

  DateTime createdAt;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Organization copyWith({
    int? id,
    String? fhirId,
    String? name,
    String? type,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? openHours,
    double? rating,
    bool? hasEmergency,
    bool? isOpen24Hours,
    String? departmentsJson,
    String? servicesJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Organization',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'name': name,
      'type': type,
      'address': address,
      if (phone != null) 'phone': phone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (openHours != null) 'openHours': openHours,
      if (rating != null) 'rating': rating,
      'hasEmergency': hasEmergency,
      'isOpen24Hours': isOpen24Hours,
      if (departmentsJson != null) 'departmentsJson': departmentsJson,
      if (servicesJson != null) 'servicesJson': servicesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    required String address,
    String? phone,
    double? latitude,
    double? longitude,
    String? openHours,
    double? rating,
    required bool hasEmergency,
    required bool isOpen24Hours,
    String? departmentsJson,
    String? servicesJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         fhirId: fhirId,
         name: name,
         type: type,
         address: address,
         phone: phone,
         latitude: latitude,
         longitude: longitude,
         openHours: openHours,
         rating: rating,
         hasEmergency: hasEmergency,
         isOpen24Hours: isOpen24Hours,
         departmentsJson: departmentsJson,
         servicesJson: servicesJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Organization copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? name,
    String? type,
    String? address,
    Object? phone = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? openHours = _Undefined,
    Object? rating = _Undefined,
    bool? hasEmergency,
    bool? isOpen24Hours,
    Object? departmentsJson = _Undefined,
    Object? servicesJson = _Undefined,
    DateTime? createdAt,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      phone: phone is String? ? phone : this.phone,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      openHours: openHours is String? ? openHours : this.openHours,
      rating: rating is double? ? rating : this.rating,
      hasEmergency: hasEmergency ?? this.hasEmergency,
      isOpen24Hours: isOpen24Hours ?? this.isOpen24Hours,
      departmentsJson: departmentsJson is String?
          ? departmentsJson
          : this.departmentsJson,
      servicesJson: servicesJson is String? ? servicesJson : this.servicesJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
