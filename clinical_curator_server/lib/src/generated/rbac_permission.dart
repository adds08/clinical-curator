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

/// Role-based access control permission entry.
abstract class RbacPermission
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = RbacPermissionTable();

  static const db = RbacPermissionRepository._();

  @override
  int? id;

  String roleId;

  String roleName;

  String resource;

  String action;

  bool isAllowed;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static RbacPermissionInclude include() {
    return RbacPermissionInclude._();
  }

  static RbacPermissionIncludeList includeList({
    _i1.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RbacPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RbacPermissionTable>? orderByList,
    RbacPermissionInclude? include,
  }) {
    return RbacPermissionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacPermission.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RbacPermission.t),
      include: include,
    );
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

class RbacPermissionUpdateTable extends _i1.UpdateTable<RbacPermissionTable> {
  RbacPermissionUpdateTable(super.table);

  _i1.ColumnValue<String, String> roleId(String value) => _i1.ColumnValue(
    table.roleId,
    value,
  );

  _i1.ColumnValue<String, String> roleName(String value) => _i1.ColumnValue(
    table.roleName,
    value,
  );

  _i1.ColumnValue<String, String> resource(String value) => _i1.ColumnValue(
    table.resource,
    value,
  );

  _i1.ColumnValue<String, String> action(String value) => _i1.ColumnValue(
    table.action,
    value,
  );

  _i1.ColumnValue<bool, bool> isAllowed(bool value) => _i1.ColumnValue(
    table.isAllowed,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class RbacPermissionTable extends _i1.Table<int?> {
  RbacPermissionTable({super.tableRelation})
    : super(tableName: 'rbac_permissions') {
    updateTable = RbacPermissionUpdateTable(this);
    roleId = _i1.ColumnString(
      'roleId',
      this,
    );
    roleName = _i1.ColumnString(
      'roleName',
      this,
    );
    resource = _i1.ColumnString(
      'resource',
      this,
    );
    action = _i1.ColumnString(
      'action',
      this,
    );
    isAllowed = _i1.ColumnBool(
      'isAllowed',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final RbacPermissionUpdateTable updateTable;

  late final _i1.ColumnString roleId;

  late final _i1.ColumnString roleName;

  late final _i1.ColumnString resource;

  late final _i1.ColumnString action;

  late final _i1.ColumnBool isAllowed;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    roleId,
    roleName,
    resource,
    action,
    isAllowed,
    createdAt,
    updatedAt,
  ];
}

class RbacPermissionInclude extends _i1.IncludeObject {
  RbacPermissionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RbacPermission.t;
}

class RbacPermissionIncludeList extends _i1.IncludeList {
  RbacPermissionIncludeList._({
    _i1.WhereExpressionBuilder<RbacPermissionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RbacPermission.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RbacPermission.t;
}

class RbacPermissionRepository {
  const RbacPermissionRepository._();

  /// Returns a list of [RbacPermission]s matching the given query parameters.
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
  Future<List<RbacPermission>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RbacPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RbacPermission>(
      where: where?.call(RbacPermission.t),
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RbacPermission] matching the given query parameters.
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
  Future<RbacPermission?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? offset,
    _i1.OrderByBuilder<RbacPermissionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RbacPermissionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RbacPermission>(
      where: where?.call(RbacPermission.t),
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RbacPermission] by its [id] or null if no such row exists.
  Future<RbacPermission?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RbacPermission>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RbacPermission]s in the list and returns the inserted rows.
  ///
  /// The returned [RbacPermission]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RbacPermission>> insert(
    _i1.DatabaseSession session,
    List<RbacPermission> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RbacPermission>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RbacPermission] and returns the inserted row.
  ///
  /// The returned [RbacPermission] will have its `id` field set.
  Future<RbacPermission> insertRow(
    _i1.DatabaseSession session,
    RbacPermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RbacPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RbacPermission]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RbacPermission>> update(
    _i1.DatabaseSession session,
    List<RbacPermission> rows, {
    _i1.ColumnSelections<RbacPermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RbacPermission>(
      rows,
      columns: columns?.call(RbacPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacPermission]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RbacPermission> updateRow(
    _i1.DatabaseSession session,
    RbacPermission row, {
    _i1.ColumnSelections<RbacPermissionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RbacPermission>(
      row,
      columns: columns?.call(RbacPermission.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RbacPermission] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RbacPermission?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RbacPermissionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RbacPermission>(
      id,
      columnValues: columnValues(RbacPermission.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RbacPermission]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RbacPermission>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RbacPermissionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RbacPermissionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RbacPermissionTable>? orderBy,
    _i1.OrderByListBuilder<RbacPermissionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RbacPermission>(
      columnValues: columnValues(RbacPermission.t.updateTable),
      where: where(RbacPermission.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RbacPermission.t),
      orderByList: orderByList?.call(RbacPermission.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RbacPermission]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RbacPermission>> delete(
    _i1.DatabaseSession session,
    List<RbacPermission> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RbacPermission>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RbacPermission].
  Future<RbacPermission> deleteRow(
    _i1.DatabaseSession session,
    RbacPermission row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RbacPermission>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RbacPermission>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RbacPermissionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RbacPermission>(
      where: where(RbacPermission.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RbacPermissionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RbacPermission>(
      where: where?.call(RbacPermission.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RbacPermission] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RbacPermissionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RbacPermission>(
      where: where(RbacPermission.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
