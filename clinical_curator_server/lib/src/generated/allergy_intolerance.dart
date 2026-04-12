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

/// Patient allergy or intolerance record.
abstract class AllergyIntolerance
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AllergyIntolerance._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.code,
    required this.displayName,
    required this.clinicalStatus,
    required this.verificationStatus,
    required this.type,
    required this.category,
    required this.criticality,
    this.onsetDate,
    this.reactionJson,
    this.recorderRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory AllergyIntolerance({
    int? id,
    String? fhirId,
    required String patientRef,
    required String code,
    required String displayName,
    required String clinicalStatus,
    required String verificationStatus,
    required String type,
    required String category,
    required String criticality,
    DateTime? onsetDate,
    String? reactionJson,
    String? recorderRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _AllergyIntoleranceImpl;

  factory AllergyIntolerance.fromJson(Map<String, dynamic> jsonSerialization) {
    return AllergyIntolerance(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      clinicalStatus: jsonSerialization['clinicalStatus'] as String,
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      type: jsonSerialization['type'] as String,
      category: jsonSerialization['category'] as String,
      criticality: jsonSerialization['criticality'] as String,
      onsetDate: jsonSerialization['onsetDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['onsetDate']),
      reactionJson: jsonSerialization['reactionJson'] as String?,
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

  static final t = AllergyIntoleranceTable();

  static const db = AllergyIntoleranceRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String code;

  String displayName;

  String clinicalStatus;

  String verificationStatus;

  String type;

  String category;

  String criticality;

  DateTime? onsetDate;

  String? reactionJson;

  String? recorderRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AllergyIntolerance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AllergyIntolerance copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? code,
    String? displayName,
    String? clinicalStatus,
    String? verificationStatus,
    String? type,
    String? category,
    String? criticality,
    DateTime? onsetDate,
    String? reactionJson,
    String? recorderRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AllergyIntolerance',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'code': code,
      'displayName': displayName,
      'clinicalStatus': clinicalStatus,
      'verificationStatus': verificationStatus,
      'type': type,
      'category': category,
      'criticality': criticality,
      if (onsetDate != null) 'onsetDate': onsetDate?.toJson(),
      if (reactionJson != null) 'reactionJson': reactionJson,
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
      '__className__': 'AllergyIntolerance',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'code': code,
      'displayName': displayName,
      'clinicalStatus': clinicalStatus,
      'verificationStatus': verificationStatus,
      'type': type,
      'category': category,
      'criticality': criticality,
      if (onsetDate != null) 'onsetDate': onsetDate?.toJson(),
      if (reactionJson != null) 'reactionJson': reactionJson,
      if (recorderRef != null) 'recorderRef': recorderRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static AllergyIntoleranceInclude include() {
    return AllergyIntoleranceInclude._();
  }

  static AllergyIntoleranceIncludeList includeList({
    _i1.WhereExpressionBuilder<AllergyIntoleranceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AllergyIntoleranceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AllergyIntoleranceTable>? orderByList,
    AllergyIntoleranceInclude? include,
  }) {
    return AllergyIntoleranceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AllergyIntolerance.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AllergyIntolerance.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AllergyIntoleranceImpl extends AllergyIntolerance {
  _AllergyIntoleranceImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String code,
    required String displayName,
    required String clinicalStatus,
    required String verificationStatus,
    required String type,
    required String category,
    required String criticality,
    DateTime? onsetDate,
    String? reactionJson,
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
         type: type,
         category: category,
         criticality: criticality,
         onsetDate: onsetDate,
         reactionJson: reactionJson,
         recorderRef: recorderRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [AllergyIntolerance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AllergyIntolerance copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? code,
    String? displayName,
    String? clinicalStatus,
    String? verificationStatus,
    String? type,
    String? category,
    String? criticality,
    Object? onsetDate = _Undefined,
    Object? reactionJson = _Undefined,
    Object? recorderRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return AllergyIntolerance(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      clinicalStatus: clinicalStatus ?? this.clinicalStatus,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      type: type ?? this.type,
      category: category ?? this.category,
      criticality: criticality ?? this.criticality,
      onsetDate: onsetDate is DateTime? ? onsetDate : this.onsetDate,
      reactionJson: reactionJson is String? ? reactionJson : this.reactionJson,
      recorderRef: recorderRef is String? ? recorderRef : this.recorderRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class AllergyIntoleranceUpdateTable
    extends _i1.UpdateTable<AllergyIntoleranceTable> {
  AllergyIntoleranceUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> criticality(String value) => _i1.ColumnValue(
    table.criticality,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> onsetDate(DateTime? value) =>
      _i1.ColumnValue(
        table.onsetDate,
        value,
      );

  _i1.ColumnValue<String, String> reactionJson(String? value) =>
      _i1.ColumnValue(
        table.reactionJson,
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

class AllergyIntoleranceTable extends _i1.Table<int?> {
  AllergyIntoleranceTable({super.tableRelation})
    : super(tableName: 'allergy_intolerances') {
    updateTable = AllergyIntoleranceUpdateTable(this);
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
    type = _i1.ColumnString(
      'type',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    criticality = _i1.ColumnString(
      'criticality',
      this,
    );
    onsetDate = _i1.ColumnDateTime(
      'onsetDate',
      this,
    );
    reactionJson = _i1.ColumnString(
      'reactionJson',
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

  late final AllergyIntoleranceUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString code;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString clinicalStatus;

  late final _i1.ColumnString verificationStatus;

  late final _i1.ColumnString type;

  late final _i1.ColumnString category;

  late final _i1.ColumnString criticality;

  late final _i1.ColumnDateTime onsetDate;

  late final _i1.ColumnString reactionJson;

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
    type,
    category,
    criticality,
    onsetDate,
    reactionJson,
    recorderRef,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class AllergyIntoleranceInclude extends _i1.IncludeObject {
  AllergyIntoleranceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AllergyIntolerance.t;
}

class AllergyIntoleranceIncludeList extends _i1.IncludeList {
  AllergyIntoleranceIncludeList._({
    _i1.WhereExpressionBuilder<AllergyIntoleranceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AllergyIntolerance.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AllergyIntolerance.t;
}

class AllergyIntoleranceRepository {
  const AllergyIntoleranceRepository._();

  /// Returns a list of [AllergyIntolerance]s matching the given query parameters.
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
  Future<List<AllergyIntolerance>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AllergyIntoleranceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AllergyIntoleranceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AllergyIntoleranceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AllergyIntolerance>(
      where: where?.call(AllergyIntolerance.t),
      orderBy: orderBy?.call(AllergyIntolerance.t),
      orderByList: orderByList?.call(AllergyIntolerance.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AllergyIntolerance] matching the given query parameters.
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
  Future<AllergyIntolerance?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AllergyIntoleranceTable>? where,
    int? offset,
    _i1.OrderByBuilder<AllergyIntoleranceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AllergyIntoleranceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AllergyIntolerance>(
      where: where?.call(AllergyIntolerance.t),
      orderBy: orderBy?.call(AllergyIntolerance.t),
      orderByList: orderByList?.call(AllergyIntolerance.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AllergyIntolerance] by its [id] or null if no such row exists.
  Future<AllergyIntolerance?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AllergyIntolerance>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AllergyIntolerance]s in the list and returns the inserted rows.
  ///
  /// The returned [AllergyIntolerance]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AllergyIntolerance>> insert(
    _i1.DatabaseSession session,
    List<AllergyIntolerance> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AllergyIntolerance>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AllergyIntolerance] and returns the inserted row.
  ///
  /// The returned [AllergyIntolerance] will have its `id` field set.
  Future<AllergyIntolerance> insertRow(
    _i1.DatabaseSession session,
    AllergyIntolerance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AllergyIntolerance>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AllergyIntolerance]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AllergyIntolerance>> update(
    _i1.DatabaseSession session,
    List<AllergyIntolerance> rows, {
    _i1.ColumnSelections<AllergyIntoleranceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AllergyIntolerance>(
      rows,
      columns: columns?.call(AllergyIntolerance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AllergyIntolerance]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AllergyIntolerance> updateRow(
    _i1.DatabaseSession session,
    AllergyIntolerance row, {
    _i1.ColumnSelections<AllergyIntoleranceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AllergyIntolerance>(
      row,
      columns: columns?.call(AllergyIntolerance.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AllergyIntolerance] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AllergyIntolerance?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AllergyIntoleranceUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AllergyIntolerance>(
      id,
      columnValues: columnValues(AllergyIntolerance.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AllergyIntolerance]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AllergyIntolerance>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AllergyIntoleranceUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AllergyIntoleranceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AllergyIntoleranceTable>? orderBy,
    _i1.OrderByListBuilder<AllergyIntoleranceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AllergyIntolerance>(
      columnValues: columnValues(AllergyIntolerance.t.updateTable),
      where: where(AllergyIntolerance.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AllergyIntolerance.t),
      orderByList: orderByList?.call(AllergyIntolerance.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AllergyIntolerance]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AllergyIntolerance>> delete(
    _i1.DatabaseSession session,
    List<AllergyIntolerance> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AllergyIntolerance>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AllergyIntolerance].
  Future<AllergyIntolerance> deleteRow(
    _i1.DatabaseSession session,
    AllergyIntolerance row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AllergyIntolerance>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AllergyIntolerance>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AllergyIntoleranceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AllergyIntolerance>(
      where: where(AllergyIntolerance.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AllergyIntoleranceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AllergyIntolerance>(
      where: where?.call(AllergyIntolerance.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AllergyIntolerance] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AllergyIntoleranceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AllergyIntolerance>(
      where: where(AllergyIntolerance.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
