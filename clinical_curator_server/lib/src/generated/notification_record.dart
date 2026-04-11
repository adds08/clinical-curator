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

/// In-app notification record.
abstract class NotificationRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = NotificationRecordTable();

  static const db = NotificationRecordRepository._();

  @override
  int? id;

  String userEmail;

  String title;

  String body;

  String type;

  bool isRead;

  String? relatedResourceId;

  String? relatedRoute;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static NotificationRecordInclude include() {
    return NotificationRecordInclude._();
  }

  static NotificationRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<NotificationRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationRecordTable>? orderByList,
    NotificationRecordInclude? include,
  }) {
    return NotificationRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(NotificationRecord.t),
      include: include,
    );
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

class NotificationRecordUpdateTable
    extends _i1.UpdateTable<NotificationRecordTable> {
  NotificationRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> userEmail(String value) => _i1.ColumnValue(
    table.userEmail,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> body(String value) => _i1.ColumnValue(
    table.body,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<bool, bool> isRead(bool value) => _i1.ColumnValue(
    table.isRead,
    value,
  );

  _i1.ColumnValue<String, String> relatedResourceId(String? value) =>
      _i1.ColumnValue(
        table.relatedResourceId,
        value,
      );

  _i1.ColumnValue<String, String> relatedRoute(String? value) =>
      _i1.ColumnValue(
        table.relatedRoute,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class NotificationRecordTable extends _i1.Table<int?> {
  NotificationRecordTable({super.tableRelation})
    : super(tableName: 'notification_records') {
    updateTable = NotificationRecordUpdateTable(this);
    userEmail = _i1.ColumnString(
      'userEmail',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    body = _i1.ColumnString(
      'body',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    isRead = _i1.ColumnBool(
      'isRead',
      this,
    );
    relatedResourceId = _i1.ColumnString(
      'relatedResourceId',
      this,
    );
    relatedRoute = _i1.ColumnString(
      'relatedRoute',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final NotificationRecordUpdateTable updateTable;

  late final _i1.ColumnString userEmail;

  late final _i1.ColumnString title;

  late final _i1.ColumnString body;

  late final _i1.ColumnString type;

  late final _i1.ColumnBool isRead;

  late final _i1.ColumnString relatedResourceId;

  late final _i1.ColumnString relatedRoute;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userEmail,
    title,
    body,
    type,
    isRead,
    relatedResourceId,
    relatedRoute,
    createdAt,
  ];
}

class NotificationRecordInclude extends _i1.IncludeObject {
  NotificationRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => NotificationRecord.t;
}

class NotificationRecordIncludeList extends _i1.IncludeList {
  NotificationRecordIncludeList._({
    _i1.WhereExpressionBuilder<NotificationRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NotificationRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => NotificationRecord.t;
}

class NotificationRecordRepository {
  const NotificationRecordRepository._();

  /// Returns a list of [NotificationRecord]s matching the given query parameters.
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
  Future<List<NotificationRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NotificationRecord>(
      where: where?.call(NotificationRecord.t),
      orderBy: orderBy?.call(NotificationRecord.t),
      orderByList: orderByList?.call(NotificationRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NotificationRecord] matching the given query parameters.
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
  Future<NotificationRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<NotificationRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NotificationRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NotificationRecord>(
      where: where?.call(NotificationRecord.t),
      orderBy: orderBy?.call(NotificationRecord.t),
      orderByList: orderByList?.call(NotificationRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NotificationRecord] by its [id] or null if no such row exists.
  Future<NotificationRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NotificationRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NotificationRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [NotificationRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<NotificationRecord>> insert(
    _i1.DatabaseSession session,
    List<NotificationRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<NotificationRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [NotificationRecord] and returns the inserted row.
  ///
  /// The returned [NotificationRecord] will have its `id` field set.
  Future<NotificationRecord> insertRow(
    _i1.DatabaseSession session,
    NotificationRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<NotificationRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [NotificationRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<NotificationRecord>> update(
    _i1.DatabaseSession session,
    List<NotificationRecord> rows, {
    _i1.ColumnSelections<NotificationRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<NotificationRecord>(
      rows,
      columns: columns?.call(NotificationRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NotificationRecord> updateRow(
    _i1.DatabaseSession session,
    NotificationRecord row, {
    _i1.ColumnSelections<NotificationRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<NotificationRecord>(
      row,
      columns: columns?.call(NotificationRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NotificationRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NotificationRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<NotificationRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<NotificationRecord>(
      id,
      columnValues: columnValues(NotificationRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NotificationRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<NotificationRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<NotificationRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<NotificationRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NotificationRecordTable>? orderBy,
    _i1.OrderByListBuilder<NotificationRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<NotificationRecord>(
      columnValues: columnValues(NotificationRecord.t.updateTable),
      where: where(NotificationRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NotificationRecord.t),
      orderByList: orderByList?.call(NotificationRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [NotificationRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<NotificationRecord>> delete(
    _i1.DatabaseSession session,
    List<NotificationRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<NotificationRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [NotificationRecord].
  Future<NotificationRecord> deleteRow(
    _i1.DatabaseSession session,
    NotificationRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NotificationRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<NotificationRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<NotificationRecord>(
      where: where(NotificationRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<NotificationRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<NotificationRecord>(
      where: where?.call(NotificationRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NotificationRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<NotificationRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NotificationRecord>(
      where: where(NotificationRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
