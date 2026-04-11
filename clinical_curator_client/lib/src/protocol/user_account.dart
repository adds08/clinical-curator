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

/// User account for authentication and profile management.
abstract class UserAccount implements _i1.SerializableModel {
  UserAccount._({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.displayName,
    this.fhirPatientId,
    this.fhirPractitionerId,
    required this.isPractitioner,
    required this.isVerified,
    this.practitionerType,
    required this.accountType,
    this.avatarUrl,
    this.healthId,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserAccount({
    int? id,
    required String email,
    required String passwordHash,
    required String displayName,
    String? fhirPatientId,
    String? fhirPractitionerId,
    required bool isPractitioner,
    required bool isVerified,
    String? practitionerType,
    required String accountType,
    String? avatarUrl,
    String? healthId,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserAccountImpl;

  factory UserAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAccount(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      displayName: jsonSerialization['displayName'] as String,
      fhirPatientId: jsonSerialization['fhirPatientId'] as String?,
      fhirPractitionerId: jsonSerialization['fhirPractitionerId'] as String?,
      isPractitioner: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isPractitioner'],
      ),
      isVerified: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isVerified'],
      ),
      practitionerType: jsonSerialization['practitionerType'] as String?,
      accountType: jsonSerialization['accountType'] as String,
      avatarUrl: jsonSerialization['avatarUrl'] as String?,
      healthId: jsonSerialization['healthId'] as String?,
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

  String email;

  String passwordHash;

  String displayName;

  String? fhirPatientId;

  String? fhirPractitionerId;

  bool isPractitioner;

  bool isVerified;

  String? practitionerType;

  String accountType;

  String? avatarUrl;

  String? healthId;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserAccount copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? displayName,
    String? fhirPatientId,
    String? fhirPractitionerId,
    bool? isPractitioner,
    bool? isVerified,
    String? practitionerType,
    String? accountType,
    String? avatarUrl,
    String? healthId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'displayName': displayName,
      if (fhirPatientId != null) 'fhirPatientId': fhirPatientId,
      if (fhirPractitionerId != null) 'fhirPractitionerId': fhirPractitionerId,
      'isPractitioner': isPractitioner,
      'isVerified': isVerified,
      if (practitionerType != null) 'practitionerType': practitionerType,
      'accountType': accountType,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (healthId != null) 'healthId': healthId,
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

class _UserAccountImpl extends UserAccount {
  _UserAccountImpl({
    int? id,
    required String email,
    required String passwordHash,
    required String displayName,
    String? fhirPatientId,
    String? fhirPractitionerId,
    required bool isPractitioner,
    required bool isVerified,
    String? practitionerType,
    required String accountType,
    String? avatarUrl,
    String? healthId,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         email: email,
         passwordHash: passwordHash,
         displayName: displayName,
         fhirPatientId: fhirPatientId,
         fhirPractitionerId: fhirPractitionerId,
         isPractitioner: isPractitioner,
         isVerified: isVerified,
         practitionerType: practitionerType,
         accountType: accountType,
         avatarUrl: avatarUrl,
         healthId: healthId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserAccount copyWith({
    Object? id = _Undefined,
    String? email,
    String? passwordHash,
    String? displayName,
    Object? fhirPatientId = _Undefined,
    Object? fhirPractitionerId = _Undefined,
    bool? isPractitioner,
    bool? isVerified,
    Object? practitionerType = _Undefined,
    String? accountType,
    Object? avatarUrl = _Undefined,
    Object? healthId = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return UserAccount(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      displayName: displayName ?? this.displayName,
      fhirPatientId: fhirPatientId is String?
          ? fhirPatientId
          : this.fhirPatientId,
      fhirPractitionerId: fhirPractitionerId is String?
          ? fhirPractitionerId
          : this.fhirPractitionerId,
      isPractitioner: isPractitioner ?? this.isPractitioner,
      isVerified: isVerified ?? this.isVerified,
      practitionerType: practitionerType is String?
          ? practitionerType
          : this.practitionerType,
      accountType: accountType ?? this.accountType,
      avatarUrl: avatarUrl is String? ? avatarUrl : this.avatarUrl,
      healthId: healthId is String? ? healthId : this.healthId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
