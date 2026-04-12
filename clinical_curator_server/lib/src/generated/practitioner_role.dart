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

/// Practitioner assignment to an organization with specialty.
abstract class PractitionerRole
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PractitionerRole._({
    this.id,
    this.fhirId,
    required this.practitionerRef,
    required this.organizationRef,
    required this.code,
    this.specialty,
    this.locationRefsJson,
    this.availableTimeJson,
    required this.active,
    this.practitionerName,
    this.organizationName,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory PractitionerRole({
    int? id,
    String? fhirId,
    required String practitionerRef,
    required String organizationRef,
    required String code,
    String? specialty,
    String? locationRefsJson,
    String? availableTimeJson,
    required bool active,
    String? practitionerName,
    String? organizationName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _PractitionerRoleImpl;

  factory PractitionerRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return PractitionerRole(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      organizationRef: jsonSerialization['organizationRef'] as String,
      code: jsonSerialization['code'] as String,
      specialty: jsonSerialization['specialty'] as String?,
      locationRefsJson: jsonSerialization['locationRefsJson'] as String?,
      availableTimeJson: jsonSerialization['availableTimeJson'] as String?,
      active: _i1.BoolJsonExtension.fromJson(jsonSerialization['active']),
      practitionerName: jsonSerialization['practitionerName'] as String?,
      organizationName: jsonSerialization['organizationName'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  static final t = PractitionerRoleTable();

  static const db = PractitionerRoleRepository._();

  @override
  int? id;

  String? fhirId;

  String practitionerRef;

  String organizationRef;

  String code;

  String? specialty;

  String? locationRefsJson;

  String? availableTimeJson;

  bool active;

  String? practitionerName;

  String? organizationName;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PractitionerRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PractitionerRole copyWith({
    int? id,
    String? fhirId,
    String? practitionerRef,
    String? organizationRef,
    String? code,
    String? specialty,
    String? locationRefsJson,
    String? availableTimeJson,
    bool? active,
    String? practitionerName,
    String? organizationName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PractitionerRole',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'practitionerRef': practitionerRef,
      'organizationRef': organizationRef,
      'code': code,
      if (specialty != null) 'specialty': specialty,
      if (locationRefsJson != null) 'locationRefsJson': locationRefsJson,
      if (availableTimeJson != null) 'availableTimeJson': availableTimeJson,
      'active': active,
      if (practitionerName != null) 'practitionerName': practitionerName,
      if (organizationName != null) 'organizationName': organizationName,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PractitionerRole',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'practitionerRef': practitionerRef,
      'organizationRef': organizationRef,
      'code': code,
      if (specialty != null) 'specialty': specialty,
      if (locationRefsJson != null) 'locationRefsJson': locationRefsJson,
      if (availableTimeJson != null) 'availableTimeJson': availableTimeJson,
      'active': active,
      if (practitionerName != null) 'practitionerName': practitionerName,
      if (organizationName != null) 'organizationName': organizationName,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static PractitionerRoleInclude include() {
    return PractitionerRoleInclude._();
  }

  static PractitionerRoleIncludeList includeList({
    _i1.WhereExpressionBuilder<PractitionerRoleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PractitionerRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PractitionerRoleTable>? orderByList,
    PractitionerRoleInclude? include,
  }) {
    return PractitionerRoleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PractitionerRole.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PractitionerRole.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PractitionerRoleImpl extends PractitionerRole {
  _PractitionerRoleImpl({
    int? id,
    String? fhirId,
    required String practitionerRef,
    required String organizationRef,
    required String code,
    String? specialty,
    String? locationRefsJson,
    String? availableTimeJson,
    required bool active,
    String? practitionerName,
    String? organizationName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         practitionerRef: practitionerRef,
         organizationRef: organizationRef,
         code: code,
         specialty: specialty,
         locationRefsJson: locationRefsJson,
         availableTimeJson: availableTimeJson,
         active: active,
         practitionerName: practitionerName,
         organizationName: organizationName,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [PractitionerRole]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PractitionerRole copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? practitionerRef,
    String? organizationRef,
    String? code,
    Object? specialty = _Undefined,
    Object? locationRefsJson = _Undefined,
    Object? availableTimeJson = _Undefined,
    bool? active,
    Object? practitionerName = _Undefined,
    Object? organizationName = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return PractitionerRole(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      organizationRef: organizationRef ?? this.organizationRef,
      code: code ?? this.code,
      specialty: specialty is String? ? specialty : this.specialty,
      locationRefsJson: locationRefsJson is String?
          ? locationRefsJson
          : this.locationRefsJson,
      availableTimeJson: availableTimeJson is String?
          ? availableTimeJson
          : this.availableTimeJson,
      active: active ?? this.active,
      practitionerName: practitionerName is String?
          ? practitionerName
          : this.practitionerName,
      organizationName: organizationName is String?
          ? organizationName
          : this.organizationName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class PractitionerRoleUpdateTable
    extends _i1.UpdateTable<PractitionerRoleTable> {
  PractitionerRoleUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> practitionerRef(String value) =>
      _i1.ColumnValue(
        table.practitionerRef,
        value,
      );

  _i1.ColumnValue<String, String> organizationRef(String value) =>
      _i1.ColumnValue(
        table.organizationRef,
        value,
      );

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> specialty(String? value) => _i1.ColumnValue(
    table.specialty,
    value,
  );

  _i1.ColumnValue<String, String> locationRefsJson(String? value) =>
      _i1.ColumnValue(
        table.locationRefsJson,
        value,
      );

  _i1.ColumnValue<String, String> availableTimeJson(String? value) =>
      _i1.ColumnValue(
        table.availableTimeJson,
        value,
      );

  _i1.ColumnValue<bool, bool> active(bool value) => _i1.ColumnValue(
    table.active,
    value,
  );

  _i1.ColumnValue<String, String> practitionerName(String? value) =>
      _i1.ColumnValue(
        table.practitionerName,
        value,
      );

  _i1.ColumnValue<String, String> organizationName(String? value) =>
      _i1.ColumnValue(
        table.organizationName,
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

  _i1.ColumnValue<int, int> syncVersion(int value) => _i1.ColumnValue(
    table.syncVersion,
    value,
  );
}

class PractitionerRoleTable extends _i1.Table<int?> {
  PractitionerRoleTable({super.tableRelation})
    : super(tableName: 'practitioner_roles') {
    updateTable = PractitionerRoleUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    practitionerRef = _i1.ColumnString(
      'practitionerRef',
      this,
    );
    organizationRef = _i1.ColumnString(
      'organizationRef',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    specialty = _i1.ColumnString(
      'specialty',
      this,
    );
    locationRefsJson = _i1.ColumnString(
      'locationRefsJson',
      this,
    );
    availableTimeJson = _i1.ColumnString(
      'availableTimeJson',
      this,
    );
    active = _i1.ColumnBool(
      'active',
      this,
    );
    practitionerName = _i1.ColumnString(
      'practitionerName',
      this,
    );
    organizationName = _i1.ColumnString(
      'organizationName',
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
    syncVersion = _i1.ColumnInt(
      'syncVersion',
      this,
    );
  }

  late final PractitionerRoleUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString practitionerRef;

  late final _i1.ColumnString organizationRef;

  late final _i1.ColumnString code;

  late final _i1.ColumnString specialty;

  late final _i1.ColumnString locationRefsJson;

  late final _i1.ColumnString availableTimeJson;

  late final _i1.ColumnBool active;

  late final _i1.ColumnString practitionerName;

  late final _i1.ColumnString organizationName;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    practitionerRef,
    organizationRef,
    code,
    specialty,
    locationRefsJson,
    availableTimeJson,
    active,
    practitionerName,
    organizationName,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class PractitionerRoleInclude extends _i1.IncludeObject {
  PractitionerRoleInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PractitionerRole.t;
}

class PractitionerRoleIncludeList extends _i1.IncludeList {
  PractitionerRoleIncludeList._({
    _i1.WhereExpressionBuilder<PractitionerRoleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PractitionerRole.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PractitionerRole.t;
}

class PractitionerRoleRepository {
  const PractitionerRoleRepository._();

  /// Returns a list of [PractitionerRole]s matching the given query parameters.
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
  Future<List<PractitionerRole>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PractitionerRoleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PractitionerRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PractitionerRoleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PractitionerRole>(
      where: where?.call(PractitionerRole.t),
      orderBy: orderBy?.call(PractitionerRole.t),
      orderByList: orderByList?.call(PractitionerRole.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PractitionerRole] matching the given query parameters.
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
  Future<PractitionerRole?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PractitionerRoleTable>? where,
    int? offset,
    _i1.OrderByBuilder<PractitionerRoleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PractitionerRoleTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PractitionerRole>(
      where: where?.call(PractitionerRole.t),
      orderBy: orderBy?.call(PractitionerRole.t),
      orderByList: orderByList?.call(PractitionerRole.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PractitionerRole] by its [id] or null if no such row exists.
  Future<PractitionerRole?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PractitionerRole>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PractitionerRole]s in the list and returns the inserted rows.
  ///
  /// The returned [PractitionerRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PractitionerRole>> insert(
    _i1.DatabaseSession session,
    List<PractitionerRole> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PractitionerRole>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PractitionerRole] and returns the inserted row.
  ///
  /// The returned [PractitionerRole] will have its `id` field set.
  Future<PractitionerRole> insertRow(
    _i1.DatabaseSession session,
    PractitionerRole row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PractitionerRole>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PractitionerRole]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PractitionerRole>> update(
    _i1.DatabaseSession session,
    List<PractitionerRole> rows, {
    _i1.ColumnSelections<PractitionerRoleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PractitionerRole>(
      rows,
      columns: columns?.call(PractitionerRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PractitionerRole]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PractitionerRole> updateRow(
    _i1.DatabaseSession session,
    PractitionerRole row, {
    _i1.ColumnSelections<PractitionerRoleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PractitionerRole>(
      row,
      columns: columns?.call(PractitionerRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PractitionerRole] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PractitionerRole?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<PractitionerRoleUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PractitionerRole>(
      id,
      columnValues: columnValues(PractitionerRole.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PractitionerRole]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PractitionerRole>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PractitionerRoleUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PractitionerRoleTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PractitionerRoleTable>? orderBy,
    _i1.OrderByListBuilder<PractitionerRoleTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PractitionerRole>(
      columnValues: columnValues(PractitionerRole.t.updateTable),
      where: where(PractitionerRole.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PractitionerRole.t),
      orderByList: orderByList?.call(PractitionerRole.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PractitionerRole]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PractitionerRole>> delete(
    _i1.DatabaseSession session,
    List<PractitionerRole> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PractitionerRole>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PractitionerRole].
  Future<PractitionerRole> deleteRow(
    _i1.DatabaseSession session,
    PractitionerRole row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PractitionerRole>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PractitionerRole>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PractitionerRoleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PractitionerRole>(
      where: where(PractitionerRole.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PractitionerRoleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PractitionerRole>(
      where: where?.call(PractitionerRole.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PractitionerRole] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PractitionerRoleTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PractitionerRole>(
      where: where(PractitionerRole.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
