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

/// Patient immunization record.
abstract class Immunization implements _i1.SerializableModel {
  Immunization._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.vaccineCode,
    required this.vaccineName,
    required this.occurrenceDate,
    required this.status,
    this.lotNumber,
    this.site,
    this.routeOfAdmin,
    this.doseQuantity,
    this.performerRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Immunization({
    int? id,
    String? fhirId,
    required String patientRef,
    required String vaccineCode,
    required String vaccineName,
    required DateTime occurrenceDate,
    required String status,
    String? lotNumber,
    String? site,
    String? routeOfAdmin,
    String? doseQuantity,
    String? performerRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ImmunizationImpl;

  factory Immunization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Immunization(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      vaccineCode: jsonSerialization['vaccineCode'] as String,
      vaccineName: jsonSerialization['vaccineName'] as String,
      occurrenceDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceDate'],
      ),
      status: jsonSerialization['status'] as String,
      lotNumber: jsonSerialization['lotNumber'] as String?,
      site: jsonSerialization['site'] as String?,
      routeOfAdmin: jsonSerialization['routeOfAdmin'] as String?,
      doseQuantity: jsonSerialization['doseQuantity'] as String?,
      performerRef: jsonSerialization['performerRef'] as String?,
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

  String vaccineCode;

  String vaccineName;

  DateTime occurrenceDate;

  String status;

  String? lotNumber;

  String? site;

  String? routeOfAdmin;

  String? doseQuantity;

  String? performerRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Immunization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Immunization copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? vaccineCode,
    String? vaccineName,
    DateTime? occurrenceDate,
    String? status,
    String? lotNumber,
    String? site,
    String? routeOfAdmin,
    String? doseQuantity,
    String? performerRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Immunization',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'vaccineCode': vaccineCode,
      'vaccineName': vaccineName,
      'occurrenceDate': occurrenceDate.toJson(),
      'status': status,
      if (lotNumber != null) 'lotNumber': lotNumber,
      if (site != null) 'site': site,
      if (routeOfAdmin != null) 'routeOfAdmin': routeOfAdmin,
      if (doseQuantity != null) 'doseQuantity': doseQuantity,
      if (performerRef != null) 'performerRef': performerRef,
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

class _ImmunizationImpl extends Immunization {
  _ImmunizationImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String vaccineCode,
    required String vaccineName,
    required DateTime occurrenceDate,
    required String status,
    String? lotNumber,
    String? site,
    String? routeOfAdmin,
    String? doseQuantity,
    String? performerRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         vaccineCode: vaccineCode,
         vaccineName: vaccineName,
         occurrenceDate: occurrenceDate,
         status: status,
         lotNumber: lotNumber,
         site: site,
         routeOfAdmin: routeOfAdmin,
         doseQuantity: doseQuantity,
         performerRef: performerRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Immunization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Immunization copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? vaccineCode,
    String? vaccineName,
    DateTime? occurrenceDate,
    String? status,
    Object? lotNumber = _Undefined,
    Object? site = _Undefined,
    Object? routeOfAdmin = _Undefined,
    Object? doseQuantity = _Undefined,
    Object? performerRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Immunization(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      vaccineCode: vaccineCode ?? this.vaccineCode,
      vaccineName: vaccineName ?? this.vaccineName,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      status: status ?? this.status,
      lotNumber: lotNumber is String? ? lotNumber : this.lotNumber,
      site: site is String? ? site : this.site,
      routeOfAdmin: routeOfAdmin is String? ? routeOfAdmin : this.routeOfAdmin,
      doseQuantity: doseQuantity is String? ? doseQuantity : this.doseQuantity,
      performerRef: performerRef is String? ? performerRef : this.performerRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
