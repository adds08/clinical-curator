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

/// Clinical condition or diagnosis.
abstract class Condition
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Condition._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.code,
    required this.displayName,
    required this.clinicalStatus,
    required this.verificationStatus,
    this.onsetDate,
    this.abatementDate,
    required this.recordedDate,
    this.severity,
    this.bodySite,
    this.encounterRef,
    this.recorderRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Condition({
    int? id,
    String? fhirId,
    required String patientRef,
    required String code,
    required String displayName,
    required String clinicalStatus,
    required String verificationStatus,
    DateTime? onsetDate,
    DateTime? abatementDate,
    required DateTime recordedDate,
    String? severity,
    String? bodySite,
    String? encounterRef,
    String? recorderRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ConditionImpl;

  factory Condition.fromJson(Map<String, dynamic> jsonSerialization) {
    return Condition(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      clinicalStatus: jsonSerialization['clinicalStatus'] as String,
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      onsetDate: jsonSerialization['onsetDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['onsetDate']),
      abatementDate: jsonSerialization['abatementDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['abatementDate'],
            ),
      recordedDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['recordedDate'],
      ),
      severity: jsonSerialization['severity'] as String?,
      bodySite: jsonSerialization['bodySite'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      recorderRef: jsonSerialization['recorderRef'] as String?,
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

  static final t = ConditionTable();

  static const db = ConditionRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String code;

  String displayName;

  String clinicalStatus;

  String verificationStatus;

  DateTime? onsetDate;

  DateTime? abatementDate;

  DateTime recordedDate;

  String? severity;

  String? bodySite;

  String? encounterRef;

  String? recorderRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Condition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Condition copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? code,
    String? displayName,
    String? clinicalStatus,
    String? verificationStatus,
    DateTime? onsetDate,
    DateTime? abatementDate,
    DateTime? recordedDate,
    String? severity,
    String? bodySite,
    String? encounterRef,
    String? recorderRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Condition',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'code': code,
      'displayName': displayName,
      'clinicalStatus': clinicalStatus,
      'verificationStatus': verificationStatus,
      if (onsetDate != null) 'onsetDate': onsetDate?.toJson(),
      if (abatementDate != null) 'abatementDate': abatementDate?.toJson(),
      'recordedDate': recordedDate.toJson(),
      if (severity != null) 'severity': severity,
      if (bodySite != null) 'bodySite': bodySite,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (recorderRef != null) 'recorderRef': recorderRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Condition',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'code': code,
      'displayName': displayName,
      'clinicalStatus': clinicalStatus,
      'verificationStatus': verificationStatus,
      if (onsetDate != null) 'onsetDate': onsetDate?.toJson(),
      if (abatementDate != null) 'abatementDate': abatementDate?.toJson(),
      'recordedDate': recordedDate.toJson(),
      if (severity != null) 'severity': severity,
      if (bodySite != null) 'bodySite': bodySite,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (recorderRef != null) 'recorderRef': recorderRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static ConditionInclude include() {
    return ConditionInclude._();
  }

  static ConditionIncludeList includeList({
    _i1.WhereExpressionBuilder<ConditionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConditionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConditionTable>? orderByList,
    ConditionInclude? include,
  }) {
    return ConditionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Condition.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Condition.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConditionImpl extends Condition {
  _ConditionImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String code,
    required String displayName,
    required String clinicalStatus,
    required String verificationStatus,
    DateTime? onsetDate,
    DateTime? abatementDate,
    required DateTime recordedDate,
    String? severity,
    String? bodySite,
    String? encounterRef,
    String? recorderRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         code: code,
         displayName: displayName,
         clinicalStatus: clinicalStatus,
         verificationStatus: verificationStatus,
         onsetDate: onsetDate,
         abatementDate: abatementDate,
         recordedDate: recordedDate,
         severity: severity,
         bodySite: bodySite,
         encounterRef: encounterRef,
         recorderRef: recorderRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Condition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Condition copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? code,
    String? displayName,
    String? clinicalStatus,
    String? verificationStatus,
    Object? onsetDate = _Undefined,
    Object? abatementDate = _Undefined,
    DateTime? recordedDate,
    Object? severity = _Undefined,
    Object? bodySite = _Undefined,
    Object? encounterRef = _Undefined,
    Object? recorderRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Condition(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      clinicalStatus: clinicalStatus ?? this.clinicalStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      onsetDate: onsetDate is DateTime? ? onsetDate : this.onsetDate,
      abatementDate: abatementDate is DateTime?
          ? abatementDate
          : this.abatementDate,
      recordedDate: recordedDate ?? this.recordedDate,
      severity: severity is String? ? severity : this.severity,
      bodySite: bodySite is String? ? bodySite : this.bodySite,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      recorderRef: recorderRef is String? ? recorderRef : this.recorderRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class ConditionUpdateTable extends _i1.UpdateTable<ConditionTable> {
  ConditionUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
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

  _i1.ColumnValue<String, String> clinicalStatus(String value) =>
      _i1.ColumnValue(
        table.clinicalStatus,
        value,
      );

  _i1.ColumnValue<String, String> verificationStatus(String value) =>
      _i1.ColumnValue(
        table.verificationStatus,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> onsetDate(DateTime? value) =>
      _i1.ColumnValue(
        table.onsetDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> abatementDate(DateTime? value) =>
      _i1.ColumnValue(
        table.abatementDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> recordedDate(DateTime value) =>
      _i1.ColumnValue(
        table.recordedDate,
        value,
      );

  _i1.ColumnValue<String, String> severity(String? value) => _i1.ColumnValue(
    table.severity,
    value,
  );

  _i1.ColumnValue<String, String> bodySite(String? value) => _i1.ColumnValue(
    table.bodySite,
    value,
  );

  _i1.ColumnValue<String, String> encounterRef(String? value) =>
      _i1.ColumnValue(
        table.encounterRef,
        value,
      );

  _i1.ColumnValue<String, String> recorderRef(String? value) => _i1.ColumnValue(
    table.recorderRef,
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

class ConditionTable extends _i1.Table<int?> {
  ConditionTable({super.tableRelation}) : super(tableName: 'conditions') {
    updateTable = ConditionUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
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
    clinicalStatus = _i1.ColumnString(
      'clinicalStatus',
      this,
    );
    verificationStatus = _i1.ColumnString(
      'verificationStatus',
      this,
    );
    onsetDate = _i1.ColumnDateTime(
      'onsetDate',
      this,
    );
    abatementDate = _i1.ColumnDateTime(
      'abatementDate',
      this,
    );
    recordedDate = _i1.ColumnDateTime(
      'recordedDate',
      this,
    );
    severity = _i1.ColumnString(
      'severity',
      this,
    );
    bodySite = _i1.ColumnString(
      'bodySite',
      this,
    );
    encounterRef = _i1.ColumnString(
      'encounterRef',
      this,
    );
    recorderRef = _i1.ColumnString(
      'recorderRef',
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

  late final ConditionUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString code;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString clinicalStatus;

  late final _i1.ColumnString verificationStatus;

  late final _i1.ColumnDateTime onsetDate;

  late final _i1.ColumnDateTime abatementDate;

  late final _i1.ColumnDateTime recordedDate;

  late final _i1.ColumnString severity;

  late final _i1.ColumnString bodySite;

  late final _i1.ColumnString encounterRef;

  late final _i1.ColumnString recorderRef;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    code,
    displayName,
    clinicalStatus,
    verificationStatus,
    onsetDate,
    abatementDate,
    recordedDate,
    severity,
    bodySite,
    encounterRef,
    recorderRef,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class ConditionInclude extends _i1.IncludeObject {
  ConditionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Condition.t;
}

class ConditionIncludeList extends _i1.IncludeList {
  ConditionIncludeList._({
    _i1.WhereExpressionBuilder<ConditionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Condition.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Condition.t;
}

class ConditionRepository {
  const ConditionRepository._();

  /// Returns a list of [Condition]s matching the given query parameters.
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
  Future<List<Condition>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ConditionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConditionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConditionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Condition>(
      where: where?.call(Condition.t),
      orderBy: orderBy?.call(Condition.t),
      orderByList: orderByList?.call(Condition.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Condition] matching the given query parameters.
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
  Future<Condition?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ConditionTable>? where,
    int? offset,
    _i1.OrderByBuilder<ConditionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConditionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Condition>(
      where: where?.call(Condition.t),
      orderBy: orderBy?.call(Condition.t),
      orderByList: orderByList?.call(Condition.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Condition] by its [id] or null if no such row exists.
  Future<Condition?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Condition>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Condition]s in the list and returns the inserted rows.
  ///
  /// The returned [Condition]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Condition>> insert(
    _i1.DatabaseSession session,
    List<Condition> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Condition>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Condition] and returns the inserted row.
  ///
  /// The returned [Condition] will have its `id` field set.
  Future<Condition> insertRow(
    _i1.DatabaseSession session,
    Condition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Condition>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Condition]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Condition>> update(
    _i1.DatabaseSession session,
    List<Condition> rows, {
    _i1.ColumnSelections<ConditionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Condition>(
      rows,
      columns: columns?.call(Condition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Condition]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Condition> updateRow(
    _i1.DatabaseSession session,
    Condition row, {
    _i1.ColumnSelections<ConditionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Condition>(
      row,
      columns: columns?.call(Condition.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Condition] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Condition?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ConditionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Condition>(
      id,
      columnValues: columnValues(Condition.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Condition]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Condition>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ConditionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ConditionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConditionTable>? orderBy,
    _i1.OrderByListBuilder<ConditionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Condition>(
      columnValues: columnValues(Condition.t.updateTable),
      where: where(Condition.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Condition.t),
      orderByList: orderByList?.call(Condition.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Condition]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Condition>> delete(
    _i1.DatabaseSession session,
    List<Condition> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Condition>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Condition].
  Future<Condition> deleteRow(
    _i1.DatabaseSession session,
    Condition row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Condition>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Condition>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ConditionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Condition>(
      where: where(Condition.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ConditionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Condition>(
      where: where?.call(Condition.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Condition] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ConditionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Condition>(
      where: where(Condition.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
