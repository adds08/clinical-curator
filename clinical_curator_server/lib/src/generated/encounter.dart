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

/// Clinical encounter (visit, admission, or emergency).
abstract class Encounter
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Encounter._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.practitionerRef,
    required this.status,
    required this.classCode,
    required this.startDate,
    this.endDate,
    this.organizationRef,
    this.reasonJson,
    this.serviceType,
    this.notes,
    this.patientName,
    this.practitionerName,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Encounter({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String status,
    required String classCode,
    required DateTime startDate,
    DateTime? endDate,
    String? organizationRef,
    String? reasonJson,
    String? serviceType,
    String? notes,
    String? patientName,
    String? practitionerName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _EncounterImpl;

  factory Encounter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Encounter(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      status: jsonSerialization['status'] as String,
      classCode: jsonSerialization['classCode'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      organizationRef: jsonSerialization['organizationRef'] as String?,
      reasonJson: jsonSerialization['reasonJson'] as String?,
      serviceType: jsonSerialization['serviceType'] as String?,
      notes: jsonSerialization['notes'] as String?,
      patientName: jsonSerialization['patientName'] as String?,
      practitionerName: jsonSerialization['practitionerName'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  static final t = EncounterTable();

  static const db = EncounterRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String practitionerRef;

  String status;

  String classCode;

  DateTime startDate;

  DateTime? endDate;

  String? organizationRef;

  String? reasonJson;

  String? serviceType;

  String? notes;

  String? patientName;

  String? practitionerName;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Encounter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Encounter copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? practitionerRef,
    String? status,
    String? classCode,
    DateTime? startDate,
    DateTime? endDate,
    String? organizationRef,
    String? reasonJson,
    String? serviceType,
    String? notes,
    String? patientName,
    String? practitionerName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Encounter',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'practitionerRef': practitionerRef,
      'status': status,
      'classCode': classCode,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (serviceType != null) 'serviceType': serviceType,
      if (notes != null) 'notes': notes,
      if (patientName != null) 'patientName': patientName,
      if (practitionerName != null) 'practitionerName': practitionerName,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Encounter',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'practitionerRef': practitionerRef,
      'status': status,
      'classCode': classCode,
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (serviceType != null) 'serviceType': serviceType,
      if (notes != null) 'notes': notes,
      if (patientName != null) 'patientName': patientName,
      if (practitionerName != null) 'practitionerName': practitionerName,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static EncounterInclude include() {
    return EncounterInclude._();
  }

  static EncounterIncludeList includeList({
    _i1.WhereExpressionBuilder<EncounterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EncounterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EncounterTable>? orderByList,
    EncounterInclude? include,
  }) {
    return EncounterIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Encounter.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Encounter.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EncounterImpl extends Encounter {
  _EncounterImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String status,
    required String classCode,
    required DateTime startDate,
    DateTime? endDate,
    String? organizationRef,
    String? reasonJson,
    String? serviceType,
    String? notes,
    String? patientName,
    String? practitionerName,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         practitionerRef: practitionerRef,
         status: status,
         classCode: classCode,
         startDate: startDate,
         endDate: endDate,
         organizationRef: organizationRef,
         reasonJson: reasonJson,
         serviceType: serviceType,
         notes: notes,
         patientName: patientName,
         practitionerName: practitionerName,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Encounter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Encounter copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? practitionerRef,
    String? status,
    String? classCode,
    DateTime? startDate,
    Object? endDate = _Undefined,
    Object? organizationRef = _Undefined,
    Object? reasonJson = _Undefined,
    Object? serviceType = _Undefined,
    Object? notes = _Undefined,
    Object? patientName = _Undefined,
    Object? practitionerName = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Encounter(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      status: status ?? this.status,
      classCode: classCode ?? this.classCode,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      organizationRef: organizationRef is String?
          ? organizationRef
          : this.organizationRef,
      reasonJson: reasonJson is String? ? reasonJson : this.reasonJson,
      serviceType: serviceType is String? ? serviceType : this.serviceType,
      notes: notes is String? ? notes : this.notes,
      patientName: patientName is String? ? patientName : this.patientName,
      practitionerName: practitionerName is String?
          ? practitionerName
          : this.practitionerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class EncounterUpdateTable extends _i1.UpdateTable<EncounterTable> {
  EncounterUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> practitionerRef(String value) =>
      _i1.ColumnValue(
        table.practitionerRef,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> classCode(String value) => _i1.ColumnValue(
    table.classCode,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(
        table.startDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _i1.ColumnValue(
        table.endDate,
        value,
      );

  _i1.ColumnValue<String, String> organizationRef(String? value) =>
      _i1.ColumnValue(
        table.organizationRef,
        value,
      );

  _i1.ColumnValue<String, String> reasonJson(String? value) => _i1.ColumnValue(
    table.reasonJson,
    value,
  );

  _i1.ColumnValue<String, String> serviceType(String? value) => _i1.ColumnValue(
    table.serviceType,
    value,
  );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<String, String> patientName(String? value) => _i1.ColumnValue(
    table.patientName,
    value,
  );

  _i1.ColumnValue<String, String> practitionerName(String? value) =>
      _i1.ColumnValue(
        table.practitionerName,
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

class EncounterTable extends _i1.Table<int?> {
  EncounterTable({super.tableRelation}) : super(tableName: 'encounters') {
    updateTable = EncounterUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    practitionerRef = _i1.ColumnString(
      'practitionerRef',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    classCode = _i1.ColumnString(
      'classCode',
      this,
    );
    startDate = _i1.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _i1.ColumnDateTime(
      'endDate',
      this,
    );
    organizationRef = _i1.ColumnString(
      'organizationRef',
      this,
    );
    reasonJson = _i1.ColumnString(
      'reasonJson',
      this,
    );
    serviceType = _i1.ColumnString(
      'serviceType',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    patientName = _i1.ColumnString(
      'patientName',
      this,
    );
    practitionerName = _i1.ColumnString(
      'practitionerName',
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

  late final EncounterUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString practitionerRef;

  late final _i1.ColumnString status;

  late final _i1.ColumnString classCode;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnString organizationRef;

  late final _i1.ColumnString reasonJson;

  late final _i1.ColumnString serviceType;

  late final _i1.ColumnString notes;

  late final _i1.ColumnString patientName;

  late final _i1.ColumnString practitionerName;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    practitionerRef,
    status,
    classCode,
    startDate,
    endDate,
    organizationRef,
    reasonJson,
    serviceType,
    notes,
    patientName,
    practitionerName,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class EncounterInclude extends _i1.IncludeObject {
  EncounterInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Encounter.t;
}

class EncounterIncludeList extends _i1.IncludeList {
  EncounterIncludeList._({
    _i1.WhereExpressionBuilder<EncounterTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Encounter.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Encounter.t;
}

class EncounterRepository {
  const EncounterRepository._();

  /// Returns a list of [Encounter]s matching the given query parameters.
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
  Future<List<Encounter>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EncounterTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EncounterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EncounterTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Encounter>(
      where: where?.call(Encounter.t),
      orderBy: orderBy?.call(Encounter.t),
      orderByList: orderByList?.call(Encounter.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Encounter] matching the given query parameters.
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
  Future<Encounter?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EncounterTable>? where,
    int? offset,
    _i1.OrderByBuilder<EncounterTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EncounterTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Encounter>(
      where: where?.call(Encounter.t),
      orderBy: orderBy?.call(Encounter.t),
      orderByList: orderByList?.call(Encounter.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Encounter] by its [id] or null if no such row exists.
  Future<Encounter?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Encounter>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Encounter]s in the list and returns the inserted rows.
  ///
  /// The returned [Encounter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Encounter>> insert(
    _i1.DatabaseSession session,
    List<Encounter> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Encounter>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Encounter] and returns the inserted row.
  ///
  /// The returned [Encounter] will have its `id` field set.
  Future<Encounter> insertRow(
    _i1.DatabaseSession session,
    Encounter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Encounter>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Encounter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Encounter>> update(
    _i1.DatabaseSession session,
    List<Encounter> rows, {
    _i1.ColumnSelections<EncounterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Encounter>(
      rows,
      columns: columns?.call(Encounter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Encounter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Encounter> updateRow(
    _i1.DatabaseSession session,
    Encounter row, {
    _i1.ColumnSelections<EncounterTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Encounter>(
      row,
      columns: columns?.call(Encounter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Encounter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Encounter?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<EncounterUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Encounter>(
      id,
      columnValues: columnValues(Encounter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Encounter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Encounter>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EncounterUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EncounterTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EncounterTable>? orderBy,
    _i1.OrderByListBuilder<EncounterTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Encounter>(
      columnValues: columnValues(Encounter.t.updateTable),
      where: where(Encounter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Encounter.t),
      orderByList: orderByList?.call(Encounter.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Encounter]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Encounter>> delete(
    _i1.DatabaseSession session,
    List<Encounter> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Encounter>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Encounter].
  Future<Encounter> deleteRow(
    _i1.DatabaseSession session,
    Encounter row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Encounter>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Encounter>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EncounterTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Encounter>(
      where: where(Encounter.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EncounterTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Encounter>(
      where: where?.call(Encounter.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Encounter] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EncounterTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Encounter>(
      where: where(Encounter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
