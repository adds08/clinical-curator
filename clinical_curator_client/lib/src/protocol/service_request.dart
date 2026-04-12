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

/// Clinical service request (lab order, imaging, referral).
abstract class ServiceRequest implements _i1.SerializableModel {
  ServiceRequest._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.requesterRef,
    this.requesterName,
    required this.code,
    required this.displayName,
    required this.status,
    required this.intent,
    required this.priority,
    this.category,
    this.encounterRef,
    this.occurrenceDate,
    this.performerRef,
    this.reasonJson,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory ServiceRequest({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String code,
    required String displayName,
    required String status,
    required String intent,
    required String priority,
    String? category,
    String? encounterRef,
    DateTime? occurrenceDate,
    String? performerRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ServiceRequestImpl;

  factory ServiceRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceRequest(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      requesterRef: jsonSerialization['requesterRef'] as String,
      requesterName: jsonSerialization['requesterName'] as String?,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      status: jsonSerialization['status'] as String,
      intent: jsonSerialization['intent'] as String,
      priority: jsonSerialization['priority'] as String,
      category: jsonSerialization['category'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      occurrenceDate: jsonSerialization['occurrenceDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['occurrenceDate'],
            ),
      performerRef: jsonSerialization['performerRef'] as String?,
      reasonJson: jsonSerialization['reasonJson'] as String?,
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

  String requesterRef;

  String? requesterName;

  String code;

  String displayName;

  String status;

  String intent;

  String priority;

  String? category;

  String? encounterRef;

  DateTime? occurrenceDate;

  String? performerRef;

  String? reasonJson;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [ServiceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServiceRequest copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? requesterRef,
    String? requesterName,
    String? code,
    String? displayName,
    String? status,
    String? intent,
    String? priority,
    String? category,
    String? encounterRef,
    DateTime? occurrenceDate,
    String? performerRef,
    String? reasonJson,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceRequest',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'requesterRef': requesterRef,
      if (requesterName != null) 'requesterName': requesterName,
      'code': code,
      'displayName': displayName,
      'status': status,
      'intent': intent,
      'priority': priority,
      if (category != null) 'category': category,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (occurrenceDate != null) 'occurrenceDate': occurrenceDate?.toJson(),
      if (performerRef != null) 'performerRef': performerRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
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

class _ServiceRequestImpl extends ServiceRequest {
  _ServiceRequestImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String code,
    required String displayName,
    required String status,
    required String intent,
    required String priority,
    String? category,
    String? encounterRef,
    DateTime? occurrenceDate,
    String? performerRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         requesterRef: requesterRef,
         requesterName: requesterName,
         code: code,
         displayName: displayName,
         status: status,
         intent: intent,
         priority: priority,
         category: category,
         encounterRef: encounterRef,
         occurrenceDate: occurrenceDate,
         performerRef: performerRef,
         reasonJson: reasonJson,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [ServiceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServiceRequest copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? requesterRef,
    Object? requesterName = _Undefined,
    String? code,
    String? displayName,
    String? status,
    String? intent,
    String? priority,
    Object? category = _Undefined,
    Object? encounterRef = _Undefined,
    Object? occurrenceDate = _Undefined,
    Object? performerRef = _Undefined,
    Object? reasonJson = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return ServiceRequest(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      requesterRef: requesterRef ?? this.requesterRef,
      requesterName: requesterName is String?
          ? requesterName
          : this.requesterName,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      intent: intent ?? this.intent,
      priority: priority ?? this.priority,
      category: category is String? ? category : this.category,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      occurrenceDate: occurrenceDate is DateTime?
          ? occurrenceDate
          : this.occurrenceDate,
      performerRef: performerRef is String? ? performerRef : this.performerRef,
      reasonJson: reasonJson is String? ? reasonJson : this.reasonJson,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
