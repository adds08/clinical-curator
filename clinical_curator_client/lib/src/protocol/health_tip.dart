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

/// Health tip / article for patient education.
abstract class HealthTip implements _i1.SerializableModel {
  HealthTip._({
    this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.author,
    required this.isActive,
    required this.publishedAt,
    required this.createdAt,
  });

  factory HealthTip({
    int? id,
    required String title,
    required String summary,
    required String content,
    required String category,
    String? imageUrl,
    required String author,
    required bool isActive,
    required DateTime publishedAt,
    required DateTime createdAt,
  }) = _HealthTipImpl;

  factory HealthTip.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthTip(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      content: jsonSerialization['content'] as String,
      category: jsonSerialization['category'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      author: jsonSerialization['author'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      publishedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['publishedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String summary;

  String content;

  String category;

  String? imageUrl;

  String author;

  bool isActive;

  DateTime publishedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [HealthTip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HealthTip copyWith({
    int? id,
    String? title,
    String? summary,
    String? content,
    String? category,
    String? imageUrl,
    String? author,
    bool? isActive,
    DateTime? publishedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthTip',
      if (id != null) 'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'category': category,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'author': author,
      'isActive': isActive,
      'publishedAt': publishedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthTipImpl extends HealthTip {
  _HealthTipImpl({
    int? id,
    required String title,
    required String summary,
    required String content,
    required String category,
    String? imageUrl,
    required String author,
    required bool isActive,
    required DateTime publishedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         summary: summary,
         content: content,
         category: category,
         imageUrl: imageUrl,
         author: author,
         isActive: isActive,
         publishedAt: publishedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthTip]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HealthTip copyWith({
    Object? id = _Undefined,
    String? title,
    String? summary,
    String? content,
    String? category,
    Object? imageUrl = _Undefined,
    String? author,
    bool? isActive,
    DateTime? publishedAt,
    DateTime? createdAt,
  }) {
    return HealthTip(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      author: author ?? this.author,
      isActive: isActive ?? this.isActive,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
