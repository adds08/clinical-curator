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

/// Patient care plan with activities and goals.
abstract class CarePlan implements _i1.SerializableModel {
  CarePlan._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.status,
    required this.intent,
    required this.title,
    this.category,
    this.periodStart,
    this.periodEnd,
    this.activitiesJson,
    this.goalsJson,
    this.authorRef,
    this.encounterRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory CarePlan({
    int? id,
    String? fhirId,
    required String patientRef,
    required String status,
    required String intent,
    required String title,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? activitiesJson,
    String? goalsJson,
    String? authorRef,
    String? encounterRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _CarePlanImpl;

  factory CarePlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return CarePlan(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      status: jsonSerialization['status'] as String,
      intent: jsonSerialization['intent'] as String,
      title: jsonSerialization['title'] as String,
      category: jsonSerialization['category'] as String?,
      periodStart: jsonSerialization['periodStart'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['periodStart'],
            ),
      periodEnd: jsonSerialization['periodEnd'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['periodEnd']),
      activitiesJson: jsonSerialization['activitiesJson'] as String?,
      goalsJson: jsonSerialization['goalsJson'] as String?,
      authorRef: jsonSerialization['authorRef'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
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

  String status;

  String intent;

  String title;

  String? category;

  DateTime? periodStart;

  DateTime? periodEnd;

  String? activitiesJson;

  String? goalsJson;

  String? authorRef;

  String? encounterRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  /// Returns a shallow copy of this [CarePlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CarePlan copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? status,
    String? intent,
    String? title,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? activitiesJson,
    String? goalsJson,
    String? authorRef,
    String? encounterRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CarePlan',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'status': status,
      'intent': intent,
      'title': title,
      if (category != null) 'category': category,
      if (periodStart != null) 'periodStart': periodStart?.toJson(),
      if (periodEnd != null) 'periodEnd': periodEnd?.toJson(),
      if (activitiesJson != null) 'activitiesJson': activitiesJson,
      if (goalsJson != null) 'goalsJson': goalsJson,
      if (authorRef != null) 'authorRef': authorRef,
      if (encounterRef != null) 'encounterRef': encounterRef,
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

class _CarePlanImpl extends CarePlan {
  _CarePlanImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String status,
    required String intent,
    required String title,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? activitiesJson,
    String? goalsJson,
    String? authorRef,
    String? encounterRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         status: status,
         intent: intent,
         title: title,
         category: category,
         periodStart: periodStart,
         periodEnd: periodEnd,
         activitiesJson: activitiesJson,
         goalsJson: goalsJson,
         authorRef: authorRef,
         encounterRef: encounterRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [CarePlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CarePlan copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? status,
    String? intent,
    String? title,
    Object? category = _Undefined,
    Object? periodStart = _Undefined,
    Object? periodEnd = _Undefined,
    Object? activitiesJson = _Undefined,
    Object? goalsJson = _Undefined,
    Object? authorRef = _Undefined,
    Object? encounterRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return CarePlan(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      status: status ?? this.status,
      intent: intent ?? this.intent,
      title: title ?? this.title,
      category: category is String? ? category : this.category,
      periodStart: periodStart is DateTime? ? periodStart : this.periodStart,
      periodEnd: periodEnd is DateTime? ? periodEnd : this.periodEnd,
      activitiesJson: activitiesJson is String?
          ? activitiesJson
          : this.activitiesJson,
      goalsJson: goalsJson is String? ? goalsJson : this.goalsJson,
      authorRef: authorRef is String? ? authorRef : this.authorRef,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}
