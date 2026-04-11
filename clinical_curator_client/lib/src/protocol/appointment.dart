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

/// Medical appointment (telemedicine or in-person).
abstract class Appointment implements _i1.SerializableModel {
  Appointment._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.practitionerRef,
    required this.practitionerName,
    required this.patientName,
    required this.appointmentType,
    required this.status,
    required this.scheduledAt,
    required this.durationMinutes,
    this.specialty,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Appointment({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String practitionerName,
    required String patientName,
    required String appointmentType,
    required String status,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? specialty,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AppointmentImpl;

  factory Appointment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Appointment(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      practitionerName: jsonSerialization['practitionerName'] as String,
      patientName: jsonSerialization['patientName'] as String,
      appointmentType: jsonSerialization['appointmentType'] as String,
      status: jsonSerialization['status'] as String,
      scheduledAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledAt'],
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      specialty: jsonSerialization['specialty'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? fhirId;

  String patientRef;

  String practitionerRef;

  String practitionerName;

  String patientName;

  String appointmentType;

  String status;

  DateTime scheduledAt;

  int durationMinutes;

  String? specialty;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [Appointment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Appointment copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? practitionerRef,
    String? practitionerName,
    String? patientName,
    String? appointmentType,
    String? status,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? specialty,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Appointment',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'practitionerRef': practitionerRef,
      'practitionerName': practitionerName,
      'patientName': patientName,
      'appointmentType': appointmentType,
      'status': status,
      'scheduledAt': scheduledAt.toJson(),
      'durationMinutes': durationMinutes,
      if (specialty != null) 'specialty': specialty,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppointmentImpl extends Appointment {
  _AppointmentImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String practitionerName,
    required String patientName,
    required String appointmentType,
    required String status,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? specialty,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         practitionerRef: practitionerRef,
         practitionerName: practitionerName,
         patientName: patientName,
         appointmentType: appointmentType,
         status: status,
         scheduledAt: scheduledAt,
         durationMinutes: durationMinutes,
         specialty: specialty,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Appointment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Appointment copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? practitionerRef,
    String? practitionerName,
    String? patientName,
    String? appointmentType,
    String? status,
    DateTime? scheduledAt,
    int? durationMinutes,
    Object? specialty = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return Appointment(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      practitionerName: practitionerName ?? this.practitionerName,
      patientName: patientName ?? this.patientName,
      appointmentType: appointmentType ?? this.appointmentType,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      specialty: specialty is String? ? specialty : this.specialty,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
