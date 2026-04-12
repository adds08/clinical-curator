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

/// Clinical procedure performed on a patient.
abstract class Procedure
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Procedure._({
    this.id,
    this.fhirId,
    required this.patientRef,
    this.encounterRef,
    required this.code,
    required this.displayName,
    required this.status,
    this.performedDate,
    this.performerRef,
    this.performerName,
    this.bodySite,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Procedure({
    int? id,
    String? fhirId,
    required String patientRef,
    String? encounterRef,
    required String code,
    required String displayName,
    required String status,
    DateTime? performedDate,
    String? performerRef,
    String? performerName,
    String? bodySite,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ProcedureImpl;

  factory Procedure.fromJson(Map<String, dynamic> jsonSerialization) {
    return Procedure(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      status: jsonSerialization['status'] as String,
      performedDate: jsonSerialization['performedDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['performedDate'],
            ),
      performerRef: jsonSerialization['performerRef'] as String?,
      performerName: jsonSerialization['performerName'] as String?,
      bodySite: jsonSerialization['bodySite'] as String?,
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

  static final t = ProcedureTable();

  static const db = ProcedureRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String? encounterRef;

  String code;

  String displayName;

  String status;

  DateTime? performedDate;

  String? performerRef;

  String? performerName;

  String? bodySite;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Procedure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Procedure copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? encounterRef,
    String? code,
    String? displayName,
    String? status,
    DateTime? performedDate,
    String? performerRef,
    String? performerName,
    String? bodySite,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Procedure',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      if (encounterRef != null) 'encounterRef': encounterRef,
      'code': code,
      'displayName': displayName,
      'status': status,
      if (performedDate != null) 'performedDate': performedDate?.toJson(),
      if (performerRef != null) 'performerRef': performerRef,
      if (performerName != null) 'performerName': performerName,
      if (bodySite != null) 'bodySite': bodySite,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Procedure',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      if (encounterRef != null) 'encounterRef': encounterRef,
      'code': code,
      'displayName': displayName,
      'status': status,
      if (performedDate != null) 'performedDate': performedDate?.toJson(),
      if (performerRef != null) 'performerRef': performerRef,
      if (performerName != null) 'performerName': performerName,
      if (bodySite != null) 'bodySite': bodySite,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static ProcedureInclude include() {
    return ProcedureInclude._();
  }

  static ProcedureIncludeList includeList({
    _i1.WhereExpressionBuilder<ProcedureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProcedureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProcedureTable>? orderByList,
    ProcedureInclude? include,
  }) {
    return ProcedureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Procedure.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Procedure.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProcedureImpl extends Procedure {
  _ProcedureImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    String? encounterRef,
    required String code,
    required String displayName,
    required String status,
    DateTime? performedDate,
    String? performerRef,
    String? performerName,
    String? bodySite,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         encounterRef: encounterRef,
         code: code,
         displayName: displayName,
         status: status,
         performedDate: performedDate,
         performerRef: performerRef,
         performerName: performerName,
         bodySite: bodySite,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Procedure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Procedure copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    Object? encounterRef = _Undefined,
    String? code,
    String? displayName,
    String? status,
    Object? performedDate = _Undefined,
    Object? performerRef = _Undefined,
    Object? performerName = _Undefined,
    Object? bodySite = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Procedure(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      performedDate: performedDate is DateTime?
          ? performedDate
          : this.performedDate,
      performerRef: performerRef is String? ? performerRef : this.performerRef,
      performerName: performerName is String?
          ? performerName
          : this.performerName,
      bodySite: bodySite is String? ? bodySite : this.bodySite,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class ProcedureUpdateTable extends _i1.UpdateTable<ProcedureTable> {
  ProcedureUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> encounterRef(String? value) =>
      _i1.ColumnValue(
        table.encounterRef,
        value,
      );

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> performedDate(DateTime? value) =>
      _i1.ColumnValue(
        table.performedDate,
        value,
      );

  _i1.ColumnValue<String, String> performerRef(String? value) =>
      _i1.ColumnValue(
        table.performerRef,
        value,
      );

  _i1.ColumnValue<String, String> performerName(String? value) =>
      _i1.ColumnValue(
        table.performerName,
        value,
      );

  _i1.ColumnValue<String, String> bodySite(String? value) => _i1.ColumnValue(
    table.bodySite,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
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

class ProcedureTable extends _i1.Table<int?> {
  ProcedureTable({super.tableRelation}) : super(tableName: 'procedures') {
    updateTable = ProcedureUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    encounterRef = _i1.ColumnString(
      'encounterRef',
      this,
    );
    code = _i1.ColumnString(
      'code',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    performedDate = _i1.ColumnDateTime(
      'performedDate',
      this,
    );
    performerRef = _i1.ColumnString(
      'performerRef',
      this,
    );
    performerName = _i1.ColumnString(
      'performerName',
      this,
    );
    bodySite = _i1.ColumnString(
      'bodySite',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
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

  late final ProcedureUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString encounterRef;

  late final _i1.ColumnString code;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime performedDate;

  late final _i1.ColumnString performerRef;

  late final _i1.ColumnString performerName;

  late final _i1.ColumnString bodySite;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    encounterRef,
    code,
    displayName,
    status,
    performedDate,
    performerRef,
    performerName,
    bodySite,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class ProcedureInclude extends _i1.IncludeObject {
  ProcedureInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Procedure.t;
}

class ProcedureIncludeList extends _i1.IncludeList {
  ProcedureIncludeList._({
    _i1.WhereExpressionBuilder<ProcedureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Procedure.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Procedure.t;
}

class ProcedureRepository {
  const ProcedureRepository._();

  /// Returns a list of [Procedure]s matching the given query parameters.
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
  Future<List<Procedure>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProcedureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProcedureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProcedureTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Procedure>(
      where: where?.call(Procedure.t),
      orderBy: orderBy?.call(Procedure.t),
      orderByList: orderByList?.call(Procedure.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Procedure] matching the given query parameters.
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
  Future<Procedure?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProcedureTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProcedureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProcedureTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Procedure>(
      where: where?.call(Procedure.t),
      orderBy: orderBy?.call(Procedure.t),
      orderByList: orderByList?.call(Procedure.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Procedure] by its [id] or null if no such row exists.
  Future<Procedure?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Procedure>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Procedure]s in the list and returns the inserted rows.
  ///
  /// The returned [Procedure]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Procedure>> insert(
    _i1.DatabaseSession session,
    List<Procedure> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Procedure>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Procedure] and returns the inserted row.
  ///
  /// The returned [Procedure] will have its `id` field set.
  Future<Procedure> insertRow(
    _i1.DatabaseSession session,
    Procedure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Procedure>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Procedure]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Procedure>> update(
    _i1.DatabaseSession session,
    List<Procedure> rows, {
    _i1.ColumnSelections<ProcedureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Procedure>(
      rows,
      columns: columns?.call(Procedure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Procedure]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Procedure> updateRow(
    _i1.DatabaseSession session,
    Procedure row, {
    _i1.ColumnSelections<ProcedureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Procedure>(
      row,
      columns: columns?.call(Procedure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Procedure] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Procedure?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProcedureUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Procedure>(
      id,
      columnValues: columnValues(Procedure.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Procedure]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Procedure>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProcedureUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProcedureTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProcedureTable>? orderBy,
    _i1.OrderByListBuilder<ProcedureTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Procedure>(
      columnValues: columnValues(Procedure.t.updateTable),
      where: where(Procedure.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Procedure.t),
      orderByList: orderByList?.call(Procedure.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Procedure]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Procedure>> delete(
    _i1.DatabaseSession session,
    List<Procedure> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Procedure>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Procedure].
  Future<Procedure> deleteRow(
    _i1.DatabaseSession session,
    Procedure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Procedure>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Procedure>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProcedureTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Procedure>(
      where: where(Procedure.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProcedureTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Procedure>(
      where: where?.call(Procedure.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Procedure] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProcedureTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Procedure>(
      where: where(Procedure.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
