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

/// Doctor availability schedule slot.
abstract class ScheduleSlot
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScheduleSlot._({
    this.id,
    required this.practitionerRef,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.slotDurationMinutes,
    required this.maxPatients,
    required this.bookedCount,
    this.facilityName,
    required this.isEmergencyOverride,
    required this.isTelehealth,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory ScheduleSlot({
    int? id,
    required String practitionerRef,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int slotDurationMinutes,
    required int maxPatients,
    required int bookedCount,
    String? facilityName,
    required bool isEmergencyOverride,
    required bool isTelehealth,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ScheduleSlotImpl;

  factory ScheduleSlot.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduleSlot(
      id: jsonSerialization['id'] as int?,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      slotDurationMinutes: jsonSerialization['slotDurationMinutes'] as int,
      maxPatients: jsonSerialization['maxPatients'] as int,
      bookedCount: jsonSerialization['bookedCount'] as int,
      facilityName: jsonSerialization['facilityName'] as String?,
      isEmergencyOverride: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isEmergencyOverride'],
      ),
      isTelehealth: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isTelehealth'],
      ),
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ScheduleSlotTable();

  static const db = ScheduleSlotRepository._();

  @override
  int? id;

  String practitionerRef;

  DateTime date;

  String startTime;

  String endTime;

  int slotDurationMinutes;

  int maxPatients;

  int bookedCount;

  String? facilityName;

  bool isEmergencyOverride;

  bool isTelehealth;

  String status;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScheduleSlot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScheduleSlot copyWith({
    int? id,
    String? practitionerRef,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? slotDurationMinutes,
    int? maxPatients,
    int? bookedCount,
    String? facilityName,
    bool? isEmergencyOverride,
    bool? isTelehealth,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduleSlot',
      if (id != null) 'id': id,
      'practitionerRef': practitionerRef,
      'date': date.toJson(),
      'startTime': startTime,
      'endTime': endTime,
      'slotDurationMinutes': slotDurationMinutes,
      'maxPatients': maxPatients,
      'bookedCount': bookedCount,
      if (facilityName != null) 'facilityName': facilityName,
      'isEmergencyOverride': isEmergencyOverride,
      'isTelehealth': isTelehealth,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduleSlot',
      if (id != null) 'id': id,
      'practitionerRef': practitionerRef,
      'date': date.toJson(),
      'startTime': startTime,
      'endTime': endTime,
      'slotDurationMinutes': slotDurationMinutes,
      'maxPatients': maxPatients,
      'bookedCount': bookedCount,
      if (facilityName != null) 'facilityName': facilityName,
      'isEmergencyOverride': isEmergencyOverride,
      'isTelehealth': isTelehealth,
      'status': status,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static ScheduleSlotInclude include() {
    return ScheduleSlotInclude._();
  }

  static ScheduleSlotIncludeList includeList({
    _i1.WhereExpressionBuilder<ScheduleSlotTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScheduleSlotTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScheduleSlotTable>? orderByList,
    ScheduleSlotInclude? include,
  }) {
    return ScheduleSlotIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduleSlot.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScheduleSlot.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduleSlotImpl extends ScheduleSlot {
  _ScheduleSlotImpl({
    int? id,
    required String practitionerRef,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int slotDurationMinutes,
    required int maxPatients,
    required int bookedCount,
    String? facilityName,
    required bool isEmergencyOverride,
    required bool isTelehealth,
    required String status,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         practitionerRef: practitionerRef,
         date: date,
         startTime: startTime,
         endTime: endTime,
         slotDurationMinutes: slotDurationMinutes,
         maxPatients: maxPatients,
         bookedCount: bookedCount,
         facilityName: facilityName,
         isEmergencyOverride: isEmergencyOverride,
         isTelehealth: isTelehealth,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ScheduleSlot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScheduleSlot copyWith({
    Object? id = _Undefined,
    String? practitionerRef,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? slotDurationMinutes,
    int? maxPatients,
    int? bookedCount,
    Object? facilityName = _Undefined,
    bool? isEmergencyOverride,
    bool? isTelehealth,
    String? status,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return ScheduleSlot(
      id: id is int? ? id : this.id,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      maxPatients: maxPatients ?? this.maxPatients,
      bookedCount: bookedCount ?? this.bookedCount,
      facilityName: facilityName is String? ? facilityName : this.facilityName,
      isEmergencyOverride: isEmergencyOverride ?? this.isEmergencyOverride,
      isTelehealth: isTelehealth ?? this.isTelehealth,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class ScheduleSlotUpdateTable extends _i1.UpdateTable<ScheduleSlotTable> {
  ScheduleSlotUpdateTable(super.table);

  _i1.ColumnValue<String, String> practitionerRef(String value) =>
      _i1.ColumnValue(
        table.practitionerRef,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> startTime(String value) => _i1.ColumnValue(
    table.startTime,
    value,
  );

  _i1.ColumnValue<String, String> endTime(String value) => _i1.ColumnValue(
    table.endTime,
    value,
  );

  _i1.ColumnValue<int, int> slotDurationMinutes(int value) => _i1.ColumnValue(
    table.slotDurationMinutes,
    value,
  );

  _i1.ColumnValue<int, int> maxPatients(int value) => _i1.ColumnValue(
    table.maxPatients,
    value,
  );

  _i1.ColumnValue<int, int> bookedCount(int value) => _i1.ColumnValue(
    table.bookedCount,
    value,
  );

  _i1.ColumnValue<String, String> facilityName(String? value) =>
      _i1.ColumnValue(
        table.facilityName,
        value,
      );

  _i1.ColumnValue<bool, bool> isEmergencyOverride(bool value) =>
      _i1.ColumnValue(
        table.isEmergencyOverride,
        value,
      );

  _i1.ColumnValue<bool, bool> isTelehealth(bool value) => _i1.ColumnValue(
    table.isTelehealth,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

class ScheduleSlotTable extends _i1.Table<int?> {
  ScheduleSlotTable({super.tableRelation})
    : super(tableName: 'schedule_slots') {
    updateTable = ScheduleSlotUpdateTable(this);
    practitionerRef = _i1.ColumnString(
      'practitionerRef',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    startTime = _i1.ColumnString(
      'startTime',
      this,
    );
    endTime = _i1.ColumnString(
      'endTime',
      this,
    );
    slotDurationMinutes = _i1.ColumnInt(
      'slotDurationMinutes',
      this,
    );
    maxPatients = _i1.ColumnInt(
      'maxPatients',
      this,
    );
    bookedCount = _i1.ColumnInt(
      'bookedCount',
      this,
    );
    facilityName = _i1.ColumnString(
      'facilityName',
      this,
    );
    isEmergencyOverride = _i1.ColumnBool(
      'isEmergencyOverride',
      this,
    );
    isTelehealth = _i1.ColumnBool(
      'isTelehealth',
      this,
    );
    status = _i1.ColumnString(
      'status',
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

  late final ScheduleSlotUpdateTable updateTable;

  late final _i1.ColumnString practitionerRef;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnString startTime;

  late final _i1.ColumnString endTime;

  late final _i1.ColumnInt slotDurationMinutes;

  late final _i1.ColumnInt maxPatients;

  late final _i1.ColumnInt bookedCount;

  late final _i1.ColumnString facilityName;

  late final _i1.ColumnBool isEmergencyOverride;

  late final _i1.ColumnBool isTelehealth;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    practitionerRef,
    date,
    startTime,
    endTime,
    slotDurationMinutes,
    maxPatients,
    bookedCount,
    facilityName,
    isEmergencyOverride,
    isTelehealth,
    status,
    createdAt,
    updatedAt,
  ];
}

class ScheduleSlotInclude extends _i1.IncludeObject {
  ScheduleSlotInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ScheduleSlot.t;
}

class ScheduleSlotIncludeList extends _i1.IncludeList {
  ScheduleSlotIncludeList._({
    _i1.WhereExpressionBuilder<ScheduleSlotTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScheduleSlot.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScheduleSlot.t;
}

class ScheduleSlotRepository {
  const ScheduleSlotRepository._();

  /// Returns a list of [ScheduleSlot]s matching the given query parameters.
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
  Future<List<ScheduleSlot>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ScheduleSlotTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScheduleSlotTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScheduleSlotTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScheduleSlot>(
      where: where?.call(ScheduleSlot.t),
      orderBy: orderBy?.call(ScheduleSlot.t),
      orderByList: orderByList?.call(ScheduleSlot.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScheduleSlot] matching the given query parameters.
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
  Future<ScheduleSlot?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ScheduleSlotTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScheduleSlotTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScheduleSlotTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScheduleSlot>(
      where: where?.call(ScheduleSlot.t),
      orderBy: orderBy?.call(ScheduleSlot.t),
      orderByList: orderByList?.call(ScheduleSlot.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScheduleSlot] by its [id] or null if no such row exists.
  Future<ScheduleSlot?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScheduleSlot>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScheduleSlot]s in the list and returns the inserted rows.
  ///
  /// The returned [ScheduleSlot]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ScheduleSlot>> insert(
    _i1.DatabaseSession session,
    List<ScheduleSlot> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ScheduleSlot>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ScheduleSlot] and returns the inserted row.
  ///
  /// The returned [ScheduleSlot] will have its `id` field set.
  Future<ScheduleSlot> insertRow(
    _i1.DatabaseSession session,
    ScheduleSlot row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScheduleSlot>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScheduleSlot]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScheduleSlot>> update(
    _i1.DatabaseSession session,
    List<ScheduleSlot> rows, {
    _i1.ColumnSelections<ScheduleSlotTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScheduleSlot>(
      rows,
      columns: columns?.call(ScheduleSlot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScheduleSlot]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScheduleSlot> updateRow(
    _i1.DatabaseSession session,
    ScheduleSlot row, {
    _i1.ColumnSelections<ScheduleSlotTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScheduleSlot>(
      row,
      columns: columns?.call(ScheduleSlot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScheduleSlot] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScheduleSlot?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ScheduleSlotUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ScheduleSlot>(
      id,
      columnValues: columnValues(ScheduleSlot.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduleSlot]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ScheduleSlot>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ScheduleSlotUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ScheduleSlotTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScheduleSlotTable>? orderBy,
    _i1.OrderByListBuilder<ScheduleSlotTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ScheduleSlot>(
      columnValues: columnValues(ScheduleSlot.t.updateTable),
      where: where(ScheduleSlot.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduleSlot.t),
      orderByList: orderByList?.call(ScheduleSlot.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ScheduleSlot]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScheduleSlot>> delete(
    _i1.DatabaseSession session,
    List<ScheduleSlot> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScheduleSlot>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScheduleSlot].
  Future<ScheduleSlot> deleteRow(
    _i1.DatabaseSession session,
    ScheduleSlot row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScheduleSlot>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScheduleSlot>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ScheduleSlotTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScheduleSlot>(
      where: where(ScheduleSlot.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ScheduleSlotTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScheduleSlot>(
      where: where?.call(ScheduleSlot.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScheduleSlot] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ScheduleSlotTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScheduleSlot>(
      where: where(ScheduleSlot.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
