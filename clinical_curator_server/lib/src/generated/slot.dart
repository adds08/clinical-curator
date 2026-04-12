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

/// Bookable time slot for appointments.
abstract class Slot implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Slot._({
    this.id,
    this.fhirId,
    required this.scheduleRef,
    required this.status,
    required this.startTime,
    required this.endTime,
    this.serviceType,
    this.practitionerRef,
    this.organizationRef,
    this.maxPatients,
    this.bookedCount,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Slot({
    int? id,
    String? fhirId,
    required String scheduleRef,
    required String status,
    required DateTime startTime,
    required DateTime endTime,
    String? serviceType,
    String? practitionerRef,
    String? organizationRef,
    int? maxPatients,
    int? bookedCount,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _SlotImpl;

  factory Slot.fromJson(Map<String, dynamic> jsonSerialization) {
    return Slot(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      scheduleRef: jsonSerialization['scheduleRef'] as String,
      status: jsonSerialization['status'] as String,
      startTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startTime'],
      ),
      endTime: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endTime']),
      serviceType: jsonSerialization['serviceType'] as String?,
      practitionerRef: jsonSerialization['practitionerRef'] as String?,
      organizationRef: jsonSerialization['organizationRef'] as String?,
      maxPatients: jsonSerialization['maxPatients'] as int?,
      bookedCount: jsonSerialization['bookedCount'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  static final t = SlotTable();

  static const db = SlotRepository._();

  @override
  int? id;

  String? fhirId;

  String scheduleRef;

  String status;

  DateTime startTime;

  DateTime endTime;

  String? serviceType;

  String? practitionerRef;

  String? organizationRef;

  int? maxPatients;

  int? bookedCount;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Slot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Slot copyWith({
    int? id,
    String? fhirId,
    String? scheduleRef,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    String? serviceType,
    String? practitionerRef,
    String? organizationRef,
    int? maxPatients,
    int? bookedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Slot',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'scheduleRef': scheduleRef,
      'status': status,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      if (serviceType != null) 'serviceType': serviceType,
      if (practitionerRef != null) 'practitionerRef': practitionerRef,
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (maxPatients != null) 'maxPatients': maxPatients,
      if (bookedCount != null) 'bookedCount': bookedCount,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Slot',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'scheduleRef': scheduleRef,
      'status': status,
      'startTime': startTime.toJson(),
      'endTime': endTime.toJson(),
      if (serviceType != null) 'serviceType': serviceType,
      if (practitionerRef != null) 'practitionerRef': practitionerRef,
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (maxPatients != null) 'maxPatients': maxPatients,
      if (bookedCount != null) 'bookedCount': bookedCount,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static SlotInclude include() {
    return SlotInclude._();
  }

  static SlotIncludeList includeList({
    _i1.WhereExpressionBuilder<SlotTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SlotTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SlotTable>? orderByList,
    SlotInclude? include,
  }) {
    return SlotIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Slot.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Slot.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SlotImpl extends Slot {
  _SlotImpl({
    int? id,
    String? fhirId,
    required String scheduleRef,
    required String status,
    required DateTime startTime,
    required DateTime endTime,
    String? serviceType,
    String? practitionerRef,
    String? organizationRef,
    int? maxPatients,
    int? bookedCount,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         scheduleRef: scheduleRef,
         status: status,
         startTime: startTime,
         endTime: endTime,
         serviceType: serviceType,
         practitionerRef: practitionerRef,
         organizationRef: organizationRef,
         maxPatients: maxPatients,
         bookedCount: bookedCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Slot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Slot copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? scheduleRef,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    Object? serviceType = _Undefined,
    Object? practitionerRef = _Undefined,
    Object? organizationRef = _Undefined,
    Object? maxPatients = _Undefined,
    Object? bookedCount = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Slot(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      scheduleRef: scheduleRef ?? this.scheduleRef,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      serviceType: serviceType is String? ? serviceType : this.serviceType,
      practitionerRef: practitionerRef is String?
          ? practitionerRef
          : this.practitionerRef,
      organizationRef: organizationRef is String?
          ? organizationRef
          : this.organizationRef,
      maxPatients: maxPatients is int? ? maxPatients : this.maxPatients,
      bookedCount: bookedCount is int? ? bookedCount : this.bookedCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class SlotUpdateTable extends _i1.UpdateTable<SlotTable> {
  SlotUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> scheduleRef(String value) => _i1.ColumnValue(
    table.scheduleRef,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startTime(DateTime value) =>
      _i1.ColumnValue(
        table.startTime,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> endTime(DateTime value) =>
      _i1.ColumnValue(
        table.endTime,
        value,
      );

  _i1.ColumnValue<String, String> serviceType(String? value) => _i1.ColumnValue(
    table.serviceType,
    value,
  );

  _i1.ColumnValue<String, String> practitionerRef(String? value) =>
      _i1.ColumnValue(
        table.practitionerRef,
        value,
      );

  _i1.ColumnValue<String, String> organizationRef(String? value) =>
      _i1.ColumnValue(
        table.organizationRef,
        value,
      );

  _i1.ColumnValue<int, int> maxPatients(int? value) => _i1.ColumnValue(
    table.maxPatients,
    value,
  );

  _i1.ColumnValue<int, int> bookedCount(int? value) => _i1.ColumnValue(
    table.bookedCount,
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

class SlotTable extends _i1.Table<int?> {
  SlotTable({super.tableRelation}) : super(tableName: 'slots') {
    updateTable = SlotUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    scheduleRef = _i1.ColumnString(
      'scheduleRef',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    startTime = _i1.ColumnDateTime(
      'startTime',
      this,
    );
    endTime = _i1.ColumnDateTime(
      'endTime',
      this,
    );
    serviceType = _i1.ColumnString(
      'serviceType',
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
    maxPatients = _i1.ColumnInt(
      'maxPatients',
      this,
    );
    bookedCount = _i1.ColumnInt(
      'bookedCount',
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

  late final SlotUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString scheduleRef;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime startTime;

  late final _i1.ColumnDateTime endTime;

  late final _i1.ColumnString serviceType;

  late final _i1.ColumnString practitionerRef;

  late final _i1.ColumnString organizationRef;

  late final _i1.ColumnInt maxPatients;

  late final _i1.ColumnInt bookedCount;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    scheduleRef,
    status,
    startTime,
    endTime,
    serviceType,
    practitionerRef,
    organizationRef,
    maxPatients,
    bookedCount,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class SlotInclude extends _i1.IncludeObject {
  SlotInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Slot.t;
}

class SlotIncludeList extends _i1.IncludeList {
  SlotIncludeList._({
    _i1.WhereExpressionBuilder<SlotTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Slot.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Slot.t;
}

class SlotRepository {
  const SlotRepository._();

  /// Returns a list of [Slot]s matching the given query parameters.
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
  Future<List<Slot>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SlotTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SlotTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SlotTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Slot>(
      where: where?.call(Slot.t),
      orderBy: orderBy?.call(Slot.t),
      orderByList: orderByList?.call(Slot.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Slot] matching the given query parameters.
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
  Future<Slot?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SlotTable>? where,
    int? offset,
    _i1.OrderByBuilder<SlotTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SlotTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Slot>(
      where: where?.call(Slot.t),
      orderBy: orderBy?.call(Slot.t),
      orderByList: orderByList?.call(Slot.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Slot] by its [id] or null if no such row exists.
  Future<Slot?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Slot>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Slot]s in the list and returns the inserted rows.
  ///
  /// The returned [Slot]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Slot>> insert(
    _i1.DatabaseSession session,
    List<Slot> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Slot>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Slot] and returns the inserted row.
  ///
  /// The returned [Slot] will have its `id` field set.
  Future<Slot> insertRow(
    _i1.DatabaseSession session,
    Slot row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Slot>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Slot]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Slot>> update(
    _i1.DatabaseSession session,
    List<Slot> rows, {
    _i1.ColumnSelections<SlotTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Slot>(
      rows,
      columns: columns?.call(Slot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Slot]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Slot> updateRow(
    _i1.DatabaseSession session,
    Slot row, {
    _i1.ColumnSelections<SlotTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Slot>(
      row,
      columns: columns?.call(Slot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Slot] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Slot?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SlotUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Slot>(
      id,
      columnValues: columnValues(Slot.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Slot]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Slot>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SlotUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SlotTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SlotTable>? orderBy,
    _i1.OrderByListBuilder<SlotTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Slot>(
      columnValues: columnValues(Slot.t.updateTable),
      where: where(Slot.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Slot.t),
      orderByList: orderByList?.call(Slot.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Slot]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Slot>> delete(
    _i1.DatabaseSession session,
    List<Slot> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Slot>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Slot].
  Future<Slot> deleteRow(
    _i1.DatabaseSession session,
    Slot row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Slot>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Slot>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SlotTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Slot>(
      where: where(Slot.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SlotTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Slot>(
      where: where?.call(Slot.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Slot] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SlotTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Slot>(
      where: where(Slot.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
