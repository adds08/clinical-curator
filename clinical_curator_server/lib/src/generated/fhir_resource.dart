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

/// Stores FHIR R4 resources as JSON with denormalized index fields.
abstract class FhirResourceRecord
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FhirResourceRecord._({
    this.id,
    required this.fhirId,
    required this.resourceType,
    required this.jsonData,
    this.patientReference,
    this.practitionerReference,
    this.category,
    required this.syncVersion,
    required this.lastUpdated,
    required this.createdAt,
  });

  factory FhirResourceRecord({
    int? id,
    required String fhirId,
    required String resourceType,
    required String jsonData,
    String? patientReference,
    String? practitionerReference,
    String? category,
    required int syncVersion,
    required DateTime lastUpdated,
    required DateTime createdAt,
  }) = _FhirResourceRecordImpl;

  factory FhirResourceRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return FhirResourceRecord(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String,
      resourceType: jsonSerialization['resourceType'] as String,
      jsonData: jsonSerialization['jsonData'] as String,
      patientReference: jsonSerialization['patientReference'] as String?,
      practitionerReference:
          jsonSerialization['practitionerReference'] as String?,
      category: jsonSerialization['category'] as String?,
      syncVersion: jsonSerialization['syncVersion'] as int,
      lastUpdated: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastUpdated'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = FhirResourceRecordTable();

  static const db = FhirResourceRecordRepository._();

  @override
  int? id;

  String fhirId;

  String resourceType;

  String jsonData;

  String? patientReference;

  String? practitionerReference;

  String? category;

  int syncVersion;

  DateTime lastUpdated;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FhirResourceRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FhirResourceRecord copyWith({
    int? id,
    String? fhirId,
    String? resourceType,
    String? jsonData,
    String? patientReference,
    String? practitionerReference,
    String? category,
    int? syncVersion,
    DateTime? lastUpdated,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FhirResourceRecord',
      if (id != null) 'id': id,
      'fhirId': fhirId,
      'resourceType': resourceType,
      'jsonData': jsonData,
      if (patientReference != null) 'patientReference': patientReference,
      if (practitionerReference != null)
        'practitionerReference': practitionerReference,
      if (category != null) 'category': category,
      'syncVersion': syncVersion,
      'lastUpdated': lastUpdated.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FhirResourceRecord',
      if (id != null) 'id': id,
      'fhirId': fhirId,
      'resourceType': resourceType,
      'jsonData': jsonData,
      if (patientReference != null) 'patientReference': patientReference,
      if (practitionerReference != null)
        'practitionerReference': practitionerReference,
      if (category != null) 'category': category,
      'syncVersion': syncVersion,
      'lastUpdated': lastUpdated.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static FhirResourceRecordInclude include() {
    return FhirResourceRecordInclude._();
  }

  static FhirResourceRecordIncludeList includeList({
    _i1.WhereExpressionBuilder<FhirResourceRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FhirResourceRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FhirResourceRecordTable>? orderByList,
    FhirResourceRecordInclude? include,
  }) {
    return FhirResourceRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FhirResourceRecord.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FhirResourceRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FhirResourceRecordImpl extends FhirResourceRecord {
  _FhirResourceRecordImpl({
    int? id,
    required String fhirId,
    required String resourceType,
    required String jsonData,
    String? patientReference,
    String? practitionerReference,
    String? category,
    required int syncVersion,
    required DateTime lastUpdated,
    required DateTime createdAt,
  }) : super._(
         id: id,
         fhirId: fhirId,
         resourceType: resourceType,
         jsonData: jsonData,
         patientReference: patientReference,
         practitionerReference: practitionerReference,
         category: category,
         syncVersion: syncVersion,
         lastUpdated: lastUpdated,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FhirResourceRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FhirResourceRecord copyWith({
    Object? id = _Undefined,
    String? fhirId,
    String? resourceType,
    String? jsonData,
    Object? patientReference = _Undefined,
    Object? practitionerReference = _Undefined,
    Object? category = _Undefined,
    int? syncVersion,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return FhirResourceRecord(
      id: id is int? ? id : this.id,
      fhirId: fhirId ?? this.fhirId,
      resourceType: resourceType ?? this.resourceType,
      jsonData: jsonData ?? this.jsonData,
      patientReference: patientReference is String?
          ? patientReference
          : this.patientReference,
      practitionerReference: practitionerReference is String?
          ? practitionerReference
          : this.practitionerReference,
      category: category is String? ? category : this.category,
      syncVersion: syncVersion ?? this.syncVersion,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class FhirResourceRecordUpdateTable
    extends _i1.UpdateTable<FhirResourceRecordTable> {
  FhirResourceRecordUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> resourceType(String value) => _i1.ColumnValue(
    table.resourceType,
    value,
  );

  _i1.ColumnValue<String, String> jsonData(String value) => _i1.ColumnValue(
    table.jsonData,
    value,
  );

  _i1.ColumnValue<String, String> patientReference(String? value) =>
      _i1.ColumnValue(
        table.patientReference,
        value,
      );

  _i1.ColumnValue<String, String> practitionerReference(String? value) =>
      _i1.ColumnValue(
        table.practitionerReference,
        value,
      );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<int, int> syncVersion(int value) => _i1.ColumnValue(
    table.syncVersion,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastUpdated(DateTime value) =>
      _i1.ColumnValue(
        table.lastUpdated,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class FhirResourceRecordTable extends _i1.Table<int?> {
  FhirResourceRecordTable({super.tableRelation})
    : super(tableName: 'fhir_resources') {
    updateTable = FhirResourceRecordUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    resourceType = _i1.ColumnString(
      'resourceType',
      this,
    );
    jsonData = _i1.ColumnString(
      'jsonData',
      this,
    );
    patientReference = _i1.ColumnString(
      'patientReference',
      this,
    );
    practitionerReference = _i1.ColumnString(
      'practitionerReference',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    syncVersion = _i1.ColumnInt(
      'syncVersion',
      this,
    );
    lastUpdated = _i1.ColumnDateTime(
      'lastUpdated',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final FhirResourceRecordUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString resourceType;

  late final _i1.ColumnString jsonData;

  late final _i1.ColumnString patientReference;

  late final _i1.ColumnString practitionerReference;

  late final _i1.ColumnString category;

  late final _i1.ColumnInt syncVersion;

  late final _i1.ColumnDateTime lastUpdated;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    resourceType,
    jsonData,
    patientReference,
    practitionerReference,
    category,
    syncVersion,
    lastUpdated,
    createdAt,
  ];
}

class FhirResourceRecordInclude extends _i1.IncludeObject {
  FhirResourceRecordInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FhirResourceRecord.t;
}

class FhirResourceRecordIncludeList extends _i1.IncludeList {
  FhirResourceRecordIncludeList._({
    _i1.WhereExpressionBuilder<FhirResourceRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FhirResourceRecord.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FhirResourceRecord.t;
}

class FhirResourceRecordRepository {
  const FhirResourceRecordRepository._();

  /// Returns a list of [FhirResourceRecord]s matching the given query parameters.
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
  Future<List<FhirResourceRecord>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FhirResourceRecordTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FhirResourceRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FhirResourceRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FhirResourceRecord>(
      where: where?.call(FhirResourceRecord.t),
      orderBy: orderBy?.call(FhirResourceRecord.t),
      orderByList: orderByList?.call(FhirResourceRecord.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FhirResourceRecord] matching the given query parameters.
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
  Future<FhirResourceRecord?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FhirResourceRecordTable>? where,
    int? offset,
    _i1.OrderByBuilder<FhirResourceRecordTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FhirResourceRecordTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FhirResourceRecord>(
      where: where?.call(FhirResourceRecord.t),
      orderBy: orderBy?.call(FhirResourceRecord.t),
      orderByList: orderByList?.call(FhirResourceRecord.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FhirResourceRecord] by its [id] or null if no such row exists.
  Future<FhirResourceRecord?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FhirResourceRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FhirResourceRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [FhirResourceRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FhirResourceRecord>> insert(
    _i1.DatabaseSession session,
    List<FhirResourceRecord> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FhirResourceRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FhirResourceRecord] and returns the inserted row.
  ///
  /// The returned [FhirResourceRecord] will have its `id` field set.
  Future<FhirResourceRecord> insertRow(
    _i1.DatabaseSession session,
    FhirResourceRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FhirResourceRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FhirResourceRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FhirResourceRecord>> update(
    _i1.DatabaseSession session,
    List<FhirResourceRecord> rows, {
    _i1.ColumnSelections<FhirResourceRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FhirResourceRecord>(
      rows,
      columns: columns?.call(FhirResourceRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FhirResourceRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FhirResourceRecord> updateRow(
    _i1.DatabaseSession session,
    FhirResourceRecord row, {
    _i1.ColumnSelections<FhirResourceRecordTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FhirResourceRecord>(
      row,
      columns: columns?.call(FhirResourceRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FhirResourceRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FhirResourceRecord?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FhirResourceRecordUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FhirResourceRecord>(
      id,
      columnValues: columnValues(FhirResourceRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FhirResourceRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FhirResourceRecord>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FhirResourceRecordUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FhirResourceRecordTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FhirResourceRecordTable>? orderBy,
    _i1.OrderByListBuilder<FhirResourceRecordTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FhirResourceRecord>(
      columnValues: columnValues(FhirResourceRecord.t.updateTable),
      where: where(FhirResourceRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FhirResourceRecord.t),
      orderByList: orderByList?.call(FhirResourceRecord.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FhirResourceRecord]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FhirResourceRecord>> delete(
    _i1.DatabaseSession session,
    List<FhirResourceRecord> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FhirResourceRecord>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FhirResourceRecord].
  Future<FhirResourceRecord> deleteRow(
    _i1.DatabaseSession session,
    FhirResourceRecord row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FhirResourceRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FhirResourceRecord>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FhirResourceRecordTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FhirResourceRecord>(
      where: where(FhirResourceRecord.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FhirResourceRecordTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FhirResourceRecord>(
      where: where?.call(FhirResourceRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FhirResourceRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FhirResourceRecordTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FhirResourceRecord>(
      where: where(FhirResourceRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
