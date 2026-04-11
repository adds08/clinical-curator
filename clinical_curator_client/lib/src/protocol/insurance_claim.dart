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

/// Insurance claim submission.
abstract class InsuranceClaim implements _i1.SerializableModel {
  InsuranceClaim._({
    this.id,
    required this.patientRef,
    required this.claimType,
    required this.provider,
    required this.policyNumber,
    required this.amount,
    required this.status,
    this.description,
    this.documentsJson,
    required this.createdAt,
    this.updatedAt,
  });

  factory InsuranceClaim({
    int? id,
    required String patientRef,
    required String claimType,
    required String provider,
    required String policyNumber,
    required double amount,
    required String status,
    String? description,
    String? documentsJson,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _InsuranceClaimImpl;

  factory InsuranceClaim.fromJson(Map<String, dynamic> jsonSerialization) {
    return InsuranceClaim(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      claimType: jsonSerialization['claimType'] as String,
      provider: jsonSerialization['provider'] as String,
      policyNumber: jsonSerialization['policyNumber'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      description: jsonSerialization['description'] as String?,
      documentsJson: jsonSerialization['documentsJson'] as String?,
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

  String claimType;

  String provider;

  String policyNumber;

  double amount;

  String status;

  String? description;

  String? documentsJson;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [InsuranceClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InsuranceClaim copyWith({
    int? id,
    String? patientRef,
    String? claimType,
    String? provider,
    String? policyNumber,
    double? amount,
    String? status,
    String? description,
    String? documentsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InsuranceClaim',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'claimType': claimType,
      'provider': provider,
      'policyNumber': policyNumber,
      'amount': amount,
      'status': status,
      if (description != null) 'description': description,
      if (documentsJson != null) 'documentsJson': documentsJson,
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

class _InsuranceClaimImpl extends InsuranceClaim {
  _InsuranceClaimImpl({
    int? id,
    required String patientRef,
    required String claimType,
    required String provider,
    required String policyNumber,
    required double amount,
    required String status,
    String? description,
    String? documentsJson,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         claimType: claimType,
         provider: provider,
         policyNumber: policyNumber,
         amount: amount,
         status: status,
         description: description,
         documentsJson: documentsJson,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [InsuranceClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InsuranceClaim copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? claimType,
    String? provider,
    String? policyNumber,
    double? amount,
    String? status,
    Object? description = _Undefined,
    Object? documentsJson = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return InsuranceClaim(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      claimType: claimType ?? this.claimType,
      provider: provider ?? this.provider,
      policyNumber: policyNumber ?? this.policyNumber,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description is String? ? description : this.description,
      documentsJson: documentsJson is String?
          ? documentsJson
          : this.documentsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
