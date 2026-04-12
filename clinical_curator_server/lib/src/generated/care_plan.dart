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

/// Patient care plan with activities and goals.
abstract class CarePlan
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CarePlan._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.status,
    required this.intent,
    required this.title,
    this.category,
    this.periodStart,
    this.periodEnd,
    this.activitiesJson,
    this.goalsJson,
    this.authorRef,
    this.encounterRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory CarePlan({
    int? id,
    String? fhirId,
    required String patientRef,
    required String status,
    required String intent,
    required String title,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? activitiesJson,
    String? goalsJson,
    String? authorRef,
    String? encounterRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _CarePlanImpl;

  factory CarePlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return CarePlan(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      status: jsonSerialization['status'] as String,
      intent: jsonSerialization['intent'] as String,
      title: jsonSerialization['title'] as String,
      category: jsonSerialization['category'] as String?,
      periodStart: jsonSerialization['periodStart'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['periodStart'],
            ),
      periodEnd: jsonSerialization['periodEnd'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['periodEnd']),
      activitiesJson: jsonSerialization['activitiesJson'] as String?,
      goalsJson: jsonSerialization['goalsJson'] as String?,
      authorRef: jsonSerialization['authorRef'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
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

  static final t = CarePlanTable();

  static const db = CarePlanRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String status;

  String intent;

  String title;

  String? category;

  DateTime? periodStart;

  DateTime? periodEnd;

  String? activitiesJson;

  String? goalsJson;

  String? authorRef;

  String? encounterRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CarePlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CarePlan copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? status,
    String? intent,
    String? title,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? activitiesJson,
    String? goalsJson,
    String? authorRef,
    String? encounterRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CarePlan',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'status': status,
      'intent': intent,
      'title': title,
      if (category != null) 'category': category,
      if (periodStart != null) 'periodStart': periodStart?.toJson(),
      if (periodEnd != null) 'periodEnd': periodEnd?.toJson(),
      if (activitiesJson != null) 'activitiesJson': activitiesJson,
      if (goalsJson != null) 'goalsJson': goalsJson,
      if (authorRef != null) 'authorRef': authorRef,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CarePlan',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'status': status,
      'intent': intent,
      'title': title,
      if (category != null) 'category': category,
      if (periodStart != null) 'periodStart': periodStart?.toJson(),
      if (periodEnd != null) 'periodEnd': periodEnd?.toJson(),
      if (activitiesJson != null) 'activitiesJson': activitiesJson,
      if (goalsJson != null) 'goalsJson': goalsJson,
      if (authorRef != null) 'authorRef': authorRef,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static CarePlanInclude include() {
    return CarePlanInclude._();
  }

  static CarePlanIncludeList includeList({
    _i1.WhereExpressionBuilder<CarePlanTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CarePlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CarePlanTable>? orderByList,
    CarePlanInclude? include,
  }) {
    return CarePlanIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CarePlan.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CarePlan.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CarePlanImpl extends CarePlan {
  _CarePlanImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String status,
    required String intent,
    required String title,
    String? category,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? activitiesJson,
    String? goalsJson,
    String? authorRef,
    String? encounterRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         status: status,
         intent: intent,
         title: title,
         category: category,
         periodStart: periodStart,
         periodEnd: periodEnd,
         activitiesJson: activitiesJson,
         goalsJson: goalsJson,
         authorRef: authorRef,
         encounterRef: encounterRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [CarePlan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CarePlan copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? status,
    String? intent,
    String? title,
    Object? category = _Undefined,
    Object? periodStart = _Undefined,
    Object? periodEnd = _Undefined,
    Object? activitiesJson = _Undefined,
    Object? goalsJson = _Undefined,
    Object? authorRef = _Undefined,
    Object? encounterRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return CarePlan(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      status: status ?? this.status,
      intent: intent ?? this.intent,
      title: title ?? this.title,
      category: category is String? ? category : this.category,
      periodStart: periodStart is DateTime? ? periodStart : this.periodStart,
      periodEnd: periodEnd is DateTime? ? periodEnd : this.periodEnd,
      activitiesJson: activitiesJson is String?
          ? activitiesJson
          : this.activitiesJson,
      goalsJson: goalsJson is String? ? goalsJson : this.goalsJson,
      authorRef: authorRef is String? ? authorRef : this.authorRef,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class CarePlanUpdateTable extends _i1.UpdateTable<CarePlanTable> {
  CarePlanUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> intent(String value) => _i1.ColumnValue(
    table.intent,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> periodStart(DateTime? value) =>
      _i1.ColumnValue(
        table.periodStart,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> periodEnd(DateTime? value) =>
      _i1.ColumnValue(
        table.periodEnd,
        value,
      );

  _i1.ColumnValue<String, String> activitiesJson(String? value) =>
      _i1.ColumnValue(
        table.activitiesJson,
        value,
      );

  _i1.ColumnValue<String, String> goalsJson(String? value) => _i1.ColumnValue(
    table.goalsJson,
    value,
  );

  _i1.ColumnValue<String, String> authorRef(String? value) => _i1.ColumnValue(
    table.authorRef,
    value,
  );

  _i1.ColumnValue<String, String> encounterRef(String? value) =>
      _i1.ColumnValue(
        table.encounterRef,
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

class CarePlanTable extends _i1.Table<int?> {
  CarePlanTable({super.tableRelation}) : super(tableName: 'care_plans') {
    updateTable = CarePlanUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    intent = _i1.ColumnString(
      'intent',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    periodStart = _i1.ColumnDateTime(
      'periodStart',
      this,
    );
    periodEnd = _i1.ColumnDateTime(
      'periodEnd',
      this,
    );
    activitiesJson = _i1.ColumnString(
      'activitiesJson',
      this,
    );
    goalsJson = _i1.ColumnString(
      'goalsJson',
      this,
    );
    authorRef = _i1.ColumnString(
      'authorRef',
      this,
    );
    encounterRef = _i1.ColumnString(
      'encounterRef',
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

  late final CarePlanUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString status;

  late final _i1.ColumnString intent;

  late final _i1.ColumnString title;

  late final _i1.ColumnString category;

  late final _i1.ColumnDateTime periodStart;

  late final _i1.ColumnDateTime periodEnd;

  late final _i1.ColumnString activitiesJson;

  late final _i1.ColumnString goalsJson;

  late final _i1.ColumnString authorRef;

  late final _i1.ColumnString encounterRef;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    status,
    intent,
    title,
    category,
    periodStart,
    periodEnd,
    activitiesJson,
    goalsJson,
    authorRef,
    encounterRef,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class CarePlanInclude extends _i1.IncludeObject {
  CarePlanInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CarePlan.t;
}

class CarePlanIncludeList extends _i1.IncludeList {
  CarePlanIncludeList._({
    _i1.WhereExpressionBuilder<CarePlanTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CarePlan.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CarePlan.t;
}

class CarePlanRepository {
  const CarePlanRepository._();

  /// Returns a list of [CarePlan]s matching the given query parameters.
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
  Future<List<CarePlan>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CarePlanTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CarePlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CarePlanTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CarePlan>(
      where: where?.call(CarePlan.t),
      orderBy: orderBy?.call(CarePlan.t),
      orderByList: orderByList?.call(CarePlan.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CarePlan] matching the given query parameters.
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
  Future<CarePlan?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CarePlanTable>? where,
    int? offset,
    _i1.OrderByBuilder<CarePlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CarePlanTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CarePlan>(
      where: where?.call(CarePlan.t),
      orderBy: orderBy?.call(CarePlan.t),
      orderByList: orderByList?.call(CarePlan.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CarePlan] by its [id] or null if no such row exists.
  Future<CarePlan?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CarePlan>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CarePlan]s in the list and returns the inserted rows.
  ///
  /// The returned [CarePlan]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<CarePlan>> insert(
    _i1.DatabaseSession session,
    List<CarePlan> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<CarePlan>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [CarePlan] and returns the inserted row.
  ///
  /// The returned [CarePlan] will have its `id` field set.
  Future<CarePlan> insertRow(
    _i1.DatabaseSession session,
    CarePlan row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CarePlan>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CarePlan]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CarePlan>> update(
    _i1.DatabaseSession session,
    List<CarePlan> rows, {
    _i1.ColumnSelections<CarePlanTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CarePlan>(
      rows,
      columns: columns?.call(CarePlan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CarePlan]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CarePlan> updateRow(
    _i1.DatabaseSession session,
    CarePlan row, {
    _i1.ColumnSelections<CarePlanTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CarePlan>(
      row,
      columns: columns?.call(CarePlan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CarePlan] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CarePlan?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<CarePlanUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CarePlan>(
      id,
      columnValues: columnValues(CarePlan.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CarePlan]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CarePlan>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<CarePlanUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CarePlanTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CarePlanTable>? orderBy,
    _i1.OrderByListBuilder<CarePlanTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CarePlan>(
      columnValues: columnValues(CarePlan.t.updateTable),
      where: where(CarePlan.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CarePlan.t),
      orderByList: orderByList?.call(CarePlan.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CarePlan]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CarePlan>> delete(
    _i1.DatabaseSession session,
    List<CarePlan> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CarePlan>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CarePlan].
  Future<CarePlan> deleteRow(
    _i1.DatabaseSession session,
    CarePlan row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CarePlan>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CarePlan>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CarePlanTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CarePlan>(
      where: where(CarePlan.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<CarePlanTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CarePlan>(
      where: where?.call(CarePlan.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CarePlan] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<CarePlanTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CarePlan>(
      where: where(CarePlan.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
