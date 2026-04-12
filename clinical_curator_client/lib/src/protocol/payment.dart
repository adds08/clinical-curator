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

/// Payment record for medical services.
abstract class Payment implements _i1.SerializableModel {
  Payment._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    this.gateway,
    this.transactionId,
    this.appointmentRef,
    this.description,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Payment({
    int? id,
    String? fhirId,
    required String patientRef,
    required double amount,
    required String currency,
    required String status,
    required String method,
    String? gateway,
    String? transactionId,
    String? appointmentRef,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _PaymentImpl;

  factory Payment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Payment(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
      status: jsonSerialization['status'] as String,
      method: jsonSerialization['method'] as String,
      gateway: jsonSerialization['gateway'] as String?,
      transactionId: jsonSerialization['transactionId'] as String?,
      appointmentRef: jsonSerialization['appointmentRef'] as String?,
      description: jsonSerialization['description'] as String?,
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

  double amount;

  String currency;

  String status;

  String method;

  String? gateway;

  String? transactionId;

  String? appointmentRef;

  String? description;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Payment copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    double? amount,
    String? currency,
    String? status,
    String? method,
    String? gateway,
    String? transactionId,
    String? appointmentRef,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Payment',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'amount': amount,
      'currency': currency,
      'status': status,
      'method': method,
      if (gateway != null) 'gateway': gateway,
      if (transactionId != null) 'transactionId': transactionId,
      if (appointmentRef != null) 'appointmentRef': appointmentRef,
      if (description != null) 'description': description,
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

class _PaymentImpl extends Payment {
  _PaymentImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required double amount,
    required String currency,
    required String status,
    required String method,
    String? gateway,
    String? transactionId,
    String? appointmentRef,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         amount: amount,
         currency: currency,
         status: status,
         method: method,
         gateway: gateway,
         transactionId: transactionId,
         appointmentRef: appointmentRef,
         description: description,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Payment copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    double? amount,
    String? currency,
    String? status,
    String? method,
    Object? gateway = _Undefined,
    Object? transactionId = _Undefined,
    Object? appointmentRef = _Undefined,
    Object? description = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Payment(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      method: method ?? this.method,
      gateway: gateway is String? ? gateway : this.gateway,
      transactionId: transactionId is String?
          ? transactionId
          : this.transactionId,
      appointmentRef: appointmentRef is String?
          ? appointmentRef
          : this.appointmentRef,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
