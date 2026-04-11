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

/// Lab test booking order.
abstract class LabBooking implements _i1.SerializableModel {
  LabBooking._({
    this.id,
    required this.patientRef,
    required this.testsJson,
    required this.status,
    required this.totalPrice,
    this.scheduledAt,
    this.labName,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory LabBooking({
    int? id,
    required String patientRef,
    required String testsJson,
    required String status,
    required double totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LabBookingImpl;

  factory LabBooking.fromJson(Map<String, dynamic> jsonSerialization) {
    return LabBooking(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      testsJson: jsonSerialization['testsJson'] as String,
      status: jsonSerialization['status'] as String,
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      labName: jsonSerialization['labName'] as String?,
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

  String patientRef;

  String testsJson;

  String status;

  double totalPrice;

  DateTime? scheduledAt;

  String? labName;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [LabBooking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LabBooking copyWith({
    int? id,
    String? patientRef,
    String? testsJson,
    String? status,
    double? totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LabBooking',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'testsJson': testsJson,
      'status': status,
      'totalPrice': totalPrice,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (labName != null) 'labName': labName,
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

class _LabBookingImpl extends LabBooking {
  _LabBookingImpl({
    int? id,
    required String patientRef,
    required String testsJson,
    required String status,
    required double totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         testsJson: testsJson,
         status: status,
         totalPrice: totalPrice,
         scheduledAt: scheduledAt,
         labName: labName,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LabBooking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LabBooking copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? testsJson,
    String? status,
    double? totalPrice,
    Object? scheduledAt = _Undefined,
    Object? labName = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return LabBooking(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      testsJson: testsJson ?? this.testsJson,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      labName: labName is String? ? labName : this.labName,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
