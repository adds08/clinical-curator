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

/// Pharmacy medicine order.
abstract class PharmacyOrder implements _i1.SerializableModel {
  PharmacyOrder._({
    this.id,
    required this.patientRef,
    required this.pharmacyName,
    required this.itemsJson,
    required this.status,
    required this.totalPrice,
    this.deliveryAddress,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory PharmacyOrder({
    int? id,
    required String patientRef,
    required String pharmacyName,
    required String itemsJson,
    required String status,
    required double totalPrice,
    String? deliveryAddress,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _PharmacyOrderImpl;

  factory PharmacyOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return PharmacyOrder(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      pharmacyName: jsonSerialization['pharmacyName'] as String,
      itemsJson: jsonSerialization['itemsJson'] as String,
      status: jsonSerialization['status'] as String,
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      deliveryAddress: jsonSerialization['deliveryAddress'] as String?,
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

  String pharmacyName;

  String itemsJson;

  String status;

  double totalPrice;

  String? deliveryAddress;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [PharmacyOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PharmacyOrder copyWith({
    int? id,
    String? patientRef,
    String? pharmacyName,
    String? itemsJson,
    String? status,
    double? totalPrice,
    String? deliveryAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PharmacyOrder',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'pharmacyName': pharmacyName,
      'itemsJson': itemsJson,
      'status': status,
      'totalPrice': totalPrice,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
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

class _PharmacyOrderImpl extends PharmacyOrder {
  _PharmacyOrderImpl({
    int? id,
    required String patientRef,
    required String pharmacyName,
    required String itemsJson,
    required String status,
    required double totalPrice,
    String? deliveryAddress,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         pharmacyName: pharmacyName,
         itemsJson: itemsJson,
         status: status,
         totalPrice: totalPrice,
         deliveryAddress: deliveryAddress,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PharmacyOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PharmacyOrder copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? pharmacyName,
    String? itemsJson,
    String? status,
    double? totalPrice,
    Object? deliveryAddress = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return PharmacyOrder(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      itemsJson: itemsJson ?? this.itemsJson,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryAddress: deliveryAddress is String?
          ? deliveryAddress
          : this.deliveryAddress,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
