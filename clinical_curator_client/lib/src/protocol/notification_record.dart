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

/// In-app notification record.
abstract class NotificationRecord implements _i1.SerializableModel {
  NotificationRecord._({
    this.id,
    required this.userEmail,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    this.relatedResourceId,
    this.relatedRoute,
    required this.createdAt,
  });

  factory NotificationRecord({
    int? id,
    required String userEmail,
    required String title,
    required String body,
    required String type,
    required bool isRead,
    String? relatedResourceId,
    String? relatedRoute,
    required DateTime createdAt,
  }) = _NotificationRecordImpl;

  factory NotificationRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotificationRecord(
      id: jsonSerialization['id'] as int?,
      userEmail: jsonSerialization['userEmail'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      type: jsonSerialization['type'] as String,
      isRead: _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      relatedResourceId: jsonSerialization['relatedResourceId'] as String?,
      relatedRoute: jsonSerialization['relatedRoute'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String userEmail;

  String title;

  String body;

  String type;

  bool isRead;

  String? relatedResourceId;

  String? relatedRoute;

  DateTime createdAt;

  /// Returns a shallow copy of this [NotificationRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationRecord copyWith({
    int? id,
    String? userEmail,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    String? relatedResourceId,
    String? relatedRoute,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationRecord',
      if (id != null) 'id': id,
      'userEmail': userEmail,
      'title': title,
      'body': body,
      'type': type,
      'isRead': isRead,
      if (relatedResourceId != null) 'relatedResourceId': relatedResourceId,
      if (relatedRoute != null) 'relatedRoute': relatedRoute,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationRecordImpl extends NotificationRecord {
  _NotificationRecordImpl({
    int? id,
    required String userEmail,
    required String title,
    required String body,
    required String type,
    required bool isRead,
    String? relatedResourceId,
    String? relatedRoute,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userEmail: userEmail,
         title: title,
         body: body,
         type: type,
         isRead: isRead,
         relatedResourceId: relatedResourceId,
         relatedRoute: relatedRoute,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NotificationRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationRecord copyWith({
    Object? id = _Undefined,
    String? userEmail,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    Object? relatedResourceId = _Undefined,
    Object? relatedRoute = _Undefined,
    DateTime? createdAt,
  }) {
    return NotificationRecord(
      id: id is int? ? id : this.id,
      userEmail: userEmail ?? this.userEmail,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedResourceId: relatedResourceId is String?
          ? relatedResourceId
          : this.relatedResourceId,
      relatedRoute: relatedRoute is String? ? relatedRoute : this.relatedRoute,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
