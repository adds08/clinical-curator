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
import 'package:serverpod/serverpod.dart' as _i1;

/// Health tip / article for patient education.
abstract class HealthTip
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = HealthTipTable();

  static const db = HealthTipRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static HealthTipInclude include() {
    return HealthTipInclude._();
  }

  static HealthTipIncludeList includeList({
    _i1.WhereExpressionBuilder<HealthTipTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HealthTipTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HealthTipTable>? orderByList,
    HealthTipInclude? include,
  }) {
    return HealthTipIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthTip.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HealthTip.t),
      include: include,
    );
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

class HealthTipUpdateTable extends _i1.UpdateTable<HealthTipTable> {
  HealthTipUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> summary(String value) => _i1.ColumnValue(
    table.summary,
    value,
  );

  _i1.ColumnValue<String, String> content(String value) => _i1.ColumnValue(
    table.content,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<String, String> author(String value) => _i1.ColumnValue(
    table.author,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> publishedAt(DateTime value) =>
      _i1.ColumnValue(
        table.publishedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class HealthTipTable extends _i1.Table<int?> {
  HealthTipTable({super.tableRelation}) : super(tableName: 'health_tips') {
    updateTable = HealthTipUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    summary = _i1.ColumnString(
      'summary',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    author = _i1.ColumnString(
      'author',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    publishedAt = _i1.ColumnDateTime(
      'publishedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final HealthTipUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString summary;

  late final _i1.ColumnString content;

  late final _i1.ColumnString category;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnString author;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime publishedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    summary,
    content,
    category,
    imageUrl,
    author,
    isActive,
    publishedAt,
    createdAt,
  ];
}

class HealthTipInclude extends _i1.IncludeObject {
  HealthTipInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HealthTip.t;
}

class HealthTipIncludeList extends _i1.IncludeList {
  HealthTipIncludeList._({
    _i1.WhereExpressionBuilder<HealthTipTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HealthTip.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HealthTip.t;
}

class HealthTipRepository {
  const HealthTipRepository._();

  /// Returns a list of [HealthTip]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<HealthTip>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HealthTipTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HealthTipTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HealthTipTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HealthTip>(
      where: where?.call(HealthTip.t),
      orderBy: orderBy?.call(HealthTip.t),
      orderByList: orderByList?.call(HealthTip.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HealthTip] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<HealthTip?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HealthTipTable>? where,
    int? offset,
    _i1.OrderByBuilder<HealthTipTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HealthTipTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HealthTip>(
      where: where?.call(HealthTip.t),
      orderBy: orderBy?.call(HealthTip.t),
      orderByList: orderByList?.call(HealthTip.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HealthTip] by its [id] or null if no such row exists.
  Future<HealthTip?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HealthTip>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HealthTip]s in the list and returns the inserted rows.
  ///
  /// The returned [HealthTip]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HealthTip>> insert(
    _i1.DatabaseSession session,
    List<HealthTip> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HealthTip>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HealthTip] and returns the inserted row.
  ///
  /// The returned [HealthTip] will have its `id` field set.
  Future<HealthTip> insertRow(
    _i1.DatabaseSession session,
    HealthTip row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HealthTip>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HealthTip]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HealthTip>> update(
    _i1.DatabaseSession session,
    List<HealthTip> rows, {
    _i1.ColumnSelections<HealthTipTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HealthTip>(
      rows,
      columns: columns?.call(HealthTip.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthTip]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HealthTip> updateRow(
    _i1.DatabaseSession session,
    HealthTip row, {
    _i1.ColumnSelections<HealthTipTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HealthTip>(
      row,
      columns: columns?.call(HealthTip.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthTip] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HealthTip?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HealthTipUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HealthTip>(
      id,
      columnValues: columnValues(HealthTip.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HealthTip]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HealthTip>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HealthTipUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<HealthTipTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HealthTipTable>? orderBy,
    _i1.OrderByListBuilder<HealthTipTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HealthTip>(
      columnValues: columnValues(HealthTip.t.updateTable),
      where: where(HealthTip.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthTip.t),
      orderByList: orderByList?.call(HealthTip.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HealthTip]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HealthTip>> delete(
    _i1.DatabaseSession session,
    List<HealthTip> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HealthTip>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HealthTip].
  Future<HealthTip> deleteRow(
    _i1.DatabaseSession session,
    HealthTip row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HealthTip>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HealthTip>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HealthTipTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HealthTip>(
      where: where(HealthTip.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HealthTipTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HealthTip>(
      where: where?.call(HealthTip.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HealthTip] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HealthTipTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HealthTip>(
      where: where(HealthTip.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
