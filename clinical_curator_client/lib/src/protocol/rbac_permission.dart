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

/// Role-based access control permission entry.
abstract class RbacPermission implements _i1.SerializableModel {
  RbacPermission._({
    this.id,
    required this.roleId,
    required this.roleName,
    required this.resource,
    required this.action,
    required this.isAllowed,
    required this.createdAt,
    this.updatedAt,
  });

  factory RbacPermission({
    int? id,
    required String roleId,
    required String roleName,
    required String resource,
    required String action,
    required bool isAllowed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _RbacPermissionImpl;

  factory RbacPermission.fromJson(Map<String, dynamic> jsonSerialization) {
    return RbacPermission(
      id: jsonSerialization['id'] as int?,
      roleId: jsonSerialization['roleId'] as String,
      roleName: jsonSerialization['roleName'] as String,
      resource: jsonSerialization['resource'] as String,
      action: jsonSerialization['action'] as String,
      isAllowed: _i1.BoolJsonExtension.fromJson(jsonSerialization['isAllowed']),
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

  String roleId;

  String roleName;

  String resource;

  String action;

  bool isAllowed;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [RbacPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RbacPermission copyWith({
    int? id,
    String? roleId,
    String? roleName,
    String? resource,
    String? action,
    bool? isAllowed,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RbacPermission',
      if (id != null) 'id': id,
      'roleId': roleId,
      'roleName': roleName,
      'resource': resource,
      'action': action,
      'isAllowed': isAllowed,
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

class _RbacPermissionImpl extends RbacPermission {
  _RbacPermissionImpl({
    int? id,
    required String roleId,
    required String roleName,
    required String resource,
    required String action,
    required bool isAllowed,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         roleId: roleId,
         roleName: roleName,
         resource: resource,
         action: action,
         isAllowed: isAllowed,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RbacPermission]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RbacPermission copyWith({
    Object? id = _Undefined,
    String? roleId,
    String? roleName,
    String? resource,
    String? action,
    bool? isAllowed,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return RbacPermission(
      id: id is int? ? id : this.id,
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      resource: resource ?? this.resource,
      action: action ?? this.action,
      isAllowed: isAllowed ?? this.isAllowed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
