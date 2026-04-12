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

/// Audit trail event for compliance tracking.
abstract class AuditEvent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = AuditEventTable();

  static const db = AuditEventRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static AuditEventInclude include() {
    return AuditEventInclude._();
  }

  static AuditEventIncludeList includeList({
    _i1.WhereExpressionBuilder<AuditEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditEventTable>? orderByList,
    AuditEventInclude? include,
  }) {
    return AuditEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditEvent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuditEvent.t),
      include: include,
    );
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

class AuditEventUpdateTable extends _i1.UpdateTable<AuditEventTable> {
  AuditEventUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> recorded(DateTime value) =>
      _i1.ColumnValue(
        table.recorded,
        value,
      );

  _i1.ColumnValue<String, String> agentRef(String value) => _i1.ColumnValue(
    table.agentRef,
    value,
  );

  _i1.ColumnValue<String, String> agentName(String value) => _i1.ColumnValue(
    table.agentName,
    value,
  );

  _i1.ColumnValue<String, String> entityRef(String? value) => _i1.ColumnValue(
    table.entityRef,
    value,
  );

  _i1.ColumnValue<String, String> entityType(String? value) => _i1.ColumnValue(
    table.entityType,
    value,
  );

  _i1.ColumnValue<String, String> outcome(String value) => _i1.ColumnValue(
    table.outcome,
    value,
  );

  _i1.ColumnValue<String, String> detail(String? value) => _i1.ColumnValue(
    table.detail,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> syncVersion(int value) => _i1.ColumnValue(
    table.syncVersion,
    value,
  );
}

class AuditEventTable extends _i1.Table<int?> {
  AuditEventTable({super.tableRelation}) : super(tableName: 'audit_events') {
    updateTable = AuditEventUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    recorded = _i1.ColumnDateTime(
      'recorded',
      this,
    );
    agentRef = _i1.ColumnString(
      'agentRef',
      this,
    );
    agentName = _i1.ColumnString(
      'agentName',
      this,
    );
    entityRef = _i1.ColumnString(
      'entityRef',
      this,
    );
    entityType = _i1.ColumnString(
      'entityType',
      this,
    );
    outcome = _i1.ColumnString(
      'outcome',
      this,
    );
    detail = _i1.ColumnString(
      'detail',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    syncVersion = _i1.ColumnInt(
      'syncVersion',
      this,
    );
  }

  late final AuditEventUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString type;

  late final _i1.ColumnString action;

  late final _i1.ColumnDateTime recorded;

  late final _i1.ColumnString agentRef;

  late final _i1.ColumnString agentName;

  late final _i1.ColumnString entityRef;

  late final _i1.ColumnString entityType;

  late final _i1.ColumnString outcome;

  late final _i1.ColumnString detail;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    type,
    action,
    recorded,
    agentRef,
    agentName,
    entityRef,
    entityType,
    outcome,
    detail,
    createdAt,
    syncVersion,
  ];
}

class AuditEventInclude extends _i1.IncludeObject {
  AuditEventInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AuditEvent.t;
}

class AuditEventIncludeList extends _i1.IncludeList {
  AuditEventIncludeList._({
    _i1.WhereExpressionBuilder<AuditEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuditEvent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuditEvent.t;
}

class AuditEventRepository {
  const AuditEventRepository._();

  /// Returns a list of [AuditEvent]s matching the given query parameters.
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
  Future<List<AuditEvent>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuditEventTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuditEvent>(
      where: where?.call(AuditEvent.t),
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuditEvent] matching the given query parameters.
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
  Future<AuditEvent?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuditEventTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuditEventTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuditEventTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuditEvent>(
      where: where?.call(AuditEvent.t),
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuditEvent] by its [id] or null if no such row exists.
  Future<AuditEvent?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuditEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuditEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [AuditEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AuditEvent>> insert(
    _i1.DatabaseSession session,
    List<AuditEvent> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AuditEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AuditEvent] and returns the inserted row.
  ///
  /// The returned [AuditEvent] will have its `id` field set.
  Future<AuditEvent> insertRow(
    _i1.DatabaseSession session,
    AuditEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuditEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuditEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuditEvent>> update(
    _i1.DatabaseSession session,
    List<AuditEvent> rows, {
    _i1.ColumnSelections<AuditEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuditEvent>(
      rows,
      columns: columns?.call(AuditEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuditEvent> updateRow(
    _i1.DatabaseSession session,
    AuditEvent row, {
    _i1.ColumnSelections<AuditEventTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuditEvent>(
      row,
      columns: columns?.call(AuditEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuditEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuditEvent?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AuditEventUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AuditEvent>(
      id,
      columnValues: columnValues(AuditEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuditEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AuditEvent>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AuditEventUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AuditEventTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuditEventTable>? orderBy,
    _i1.OrderByListBuilder<AuditEventTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AuditEvent>(
      columnValues: columnValues(AuditEvent.t.updateTable),
      where: where(AuditEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuditEvent.t),
      orderByList: orderByList?.call(AuditEvent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AuditEvent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuditEvent>> delete(
    _i1.DatabaseSession session,
    List<AuditEvent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuditEvent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuditEvent].
  Future<AuditEvent> deleteRow(
    _i1.DatabaseSession session,
    AuditEvent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuditEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuditEvent>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AuditEventTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuditEvent>(
      where: where(AuditEvent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuditEventTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuditEvent>(
      where: where?.call(AuditEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuditEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AuditEventTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuditEvent>(
      where: where(AuditEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
