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

/// Audit trail event for compliance tracking.
abstract class AuditEvent implements _i1.SerializableModel {
  AuditEvent._({
    this.id,
    this.fhirId,
    required this.type,
    required this.action,
    required this.recorded,
    required this.agentRef,
    required this.agentName,
    this.entityRef,
    this.entityType,
    required this.outcome,
    this.detail,
    required this.createdAt,
    required this.syncVersion,
  });

  factory AuditEvent({
    int? id,
    String? fhirId,
    required String type,
    required String action,
    required DateTime recorded,
    required String agentRef,
    required String agentName,
    String? entityRef,
    String? entityType,
    required String outcome,
    String? detail,
    required DateTime createdAt,
    required int syncVersion,
  }) = _AuditEventImpl;

  factory AuditEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditEvent(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      type: jsonSerialization['type'] as String,
      action: jsonSerialization['action'] as String,
      recorded: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['recorded'],
      ),
      agentRef: jsonSerialization['agentRef'] as String,
      agentName: jsonSerialization['agentName'] as String,
      entityRef: jsonSerialization['entityRef'] as String?,
      entityType: jsonSerialization['entityType'] as String?,
      outcome: jsonSerialization['outcome'] as String,
      detail: jsonSerialization['detail'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? fhirId;

  String type;

  String action;

  DateTime recorded;

  String agentRef;

  String agentName;

  String? entityRef;

  String? entityType;

  String outcome;

  String? detail;

  DateTime createdAt;

  int syncVersion;

  /// Returns a shallow copy of this [AuditEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditEvent copyWith({
    int? id,
    String? fhirId,
    String? type,
    String? action,
    DateTime? recorded,
    String? agentRef,
    String? agentName,
    String? entityRef,
    String? entityType,
    String? outcome,
    String? detail,
    DateTime? createdAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditEvent',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'type': type,
      'action': action,
      'recorded': recorded.toJson(),
      'agentRef': agentRef,
      'agentName': agentName,
      if (entityRef != null) 'entityRef': entityRef,
      if (entityType != null) 'entityType': entityType,
      'outcome': outcome,
      if (detail != null) 'detail': detail,
      'createdAt': createdAt.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditEventImpl extends AuditEvent {
  _AuditEventImpl({
    int? id,
    String? fhirId,
    required String type,
    required String action,
    required DateTime recorded,
    required String agentRef,
    required String agentName,
    String? entityRef,
    String? entityType,
    required String outcome,
    String? detail,
    required DateTime createdAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         type: type,
         action: action,
         recorded: recorded,
         agentRef: agentRef,
         agentName: agentName,
         entityRef: entityRef,
         entityType: entityType,
         outcome: outcome,
         detail: detail,
         createdAt: createdAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [AuditEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditEvent copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? type,
    String? action,
    DateTime? recorded,
    String? agentRef,
    String? agentName,
    Object? entityRef = _Undefined,
    Object? entityType = _Undefined,
    String? outcome,
    Object? detail = _Undefined,
    DateTime? createdAt,
    int? syncVersion,
  }) {
    return AuditEvent(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      type: type ?? this.type,
      action: action ?? this.action,
      recorded: recorded ?? this.recorded,
      agentRef: agentRef ?? this.agentRef,
      agentName: agentName ?? this.agentName,
      entityRef: entityRef is String? ? entityRef : this.entityRef,
      entityType: entityType is String? ? entityType : this.entityType,
      outcome: outcome ?? this.outcome,
      detail: detail is String? ? detail : this.detail,
      createdAt: createdAt ?? this.createdAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
