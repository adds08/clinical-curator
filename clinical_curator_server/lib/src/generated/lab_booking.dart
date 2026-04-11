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

/// Lab test booking order.
abstract class LabBooking
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LabBooking._({
    this.id,
    required this.patientRef,
    required this.testsJson,
    required this.status,
    required this.totalPrice,
    this.scheduledAt,
    this.labName,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory LabBooking({
    int? id,
    required String patientRef,
    required String testsJson,
    required String status,
    required double totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LabBookingImpl;

  factory LabBooking.fromJson(Map<String, dynamic> jsonSerialization) {
    return LabBooking(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      testsJson: jsonSerialization['testsJson'] as String,
      status: jsonSerialization['status'] as String,
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      labName: jsonSerialization['labName'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = LabBookingTable();

  static const db = LabBookingRepository._();

  @override
  int? id;

  String patientRef;

  String testsJson;

  String status;

  double totalPrice;

  DateTime? scheduledAt;

  String? labName;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LabBooking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LabBooking copyWith({
    int? id,
    String? patientRef,
    String? testsJson,
    String? status,
    double? totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LabBooking',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'testsJson': testsJson,
      'status': status,
      'totalPrice': totalPrice,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (labName != null) 'labName': labName,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LabBooking',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'testsJson': testsJson,
      'status': status,
      'totalPrice': totalPrice,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (labName != null) 'labName': labName,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static LabBookingInclude include() {
    return LabBookingInclude._();
  }

  static LabBookingIncludeList includeList({
    _i1.WhereExpressionBuilder<LabBookingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabBookingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabBookingTable>? orderByList,
    LabBookingInclude? include,
  }) {
    return LabBookingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LabBooking.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LabBooking.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LabBookingImpl extends LabBooking {
  _LabBookingImpl({
    int? id,
    required String patientRef,
    required String testsJson,
    required String status,
    required double totalPrice,
    DateTime? scheduledAt,
    String? labName,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         testsJson: testsJson,
         status: status,
         totalPrice: totalPrice,
         scheduledAt: scheduledAt,
         labName: labName,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LabBooking]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LabBooking copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? testsJson,
    String? status,
    double? totalPrice,
    Object? scheduledAt = _Undefined,
    Object? labName = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return LabBooking(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      testsJson: testsJson ?? this.testsJson,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      labName: labName is String? ? labName : this.labName,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class LabBookingUpdateTable extends _i1.UpdateTable<LabBookingTable> {
  LabBookingUpdateTable(super.table);

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> testsJson(String value) => _i1.ColumnValue(
    table.testsJson,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<double, double> totalPrice(double value) => _i1.ColumnValue(
    table.totalPrice,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledAt(DateTime? value) =>
      _i1.ColumnValue(
        table.scheduledAt,
        value,
      );

  _i1.ColumnValue<String, String> labName(String? value) => _i1.ColumnValue(
    table.labName,
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
}

class LabBookingTable extends _i1.Table<int?> {
  LabBookingTable({super.tableRelation}) : super(tableName: 'lab_bookings') {
    updateTable = LabBookingUpdateTable(this);
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    testsJson = _i1.ColumnString(
      'testsJson',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    totalPrice = _i1.ColumnDouble(
      'totalPrice',
      this,
    );
    scheduledAt = _i1.ColumnDateTime(
      'scheduledAt',
      this,
    );
    labName = _i1.ColumnString(
      'labName',
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
  }

  late final LabBookingUpdateTable updateTable;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString testsJson;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble totalPrice;

  late final _i1.ColumnDateTime scheduledAt;

  late final _i1.ColumnString labName;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    patientRef,
    testsJson,
    status,
    totalPrice,
    scheduledAt,
    labName,
    notes,
    createdAt,
    updatedAt,
  ];
}

class LabBookingInclude extends _i1.IncludeObject {
  LabBookingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => LabBooking.t;
}

class LabBookingIncludeList extends _i1.IncludeList {
  LabBookingIncludeList._({
    _i1.WhereExpressionBuilder<LabBookingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LabBooking.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LabBooking.t;
}

class LabBookingRepository {
  const LabBookingRepository._();

  /// Returns a list of [LabBooking]s matching the given query parameters.
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
  Future<List<LabBooking>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LabBookingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabBookingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabBookingTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LabBooking>(
      where: where?.call(LabBooking.t),
      orderBy: orderBy?.call(LabBooking.t),
      orderByList: orderByList?.call(LabBooking.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LabBooking] matching the given query parameters.
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
  Future<LabBooking?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LabBookingTable>? where,
    int? offset,
    _i1.OrderByBuilder<LabBookingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabBookingTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LabBooking>(
      where: where?.call(LabBooking.t),
      orderBy: orderBy?.call(LabBooking.t),
      orderByList: orderByList?.call(LabBooking.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LabBooking] by its [id] or null if no such row exists.
  Future<LabBooking?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LabBooking>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LabBooking]s in the list and returns the inserted rows.
  ///
  /// The returned [LabBooking]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<LabBooking>> insert(
    _i1.DatabaseSession session,
    List<LabBooking> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<LabBooking>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [LabBooking] and returns the inserted row.
  ///
  /// The returned [LabBooking] will have its `id` field set.
  Future<LabBooking> insertRow(
    _i1.DatabaseSession session,
    LabBooking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LabBooking>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LabBooking]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LabBooking>> update(
    _i1.DatabaseSession session,
    List<LabBooking> rows, {
    _i1.ColumnSelections<LabBookingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LabBooking>(
      rows,
      columns: columns?.call(LabBooking.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LabBooking]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LabBooking> updateRow(
    _i1.DatabaseSession session,
    LabBooking row, {
    _i1.ColumnSelections<LabBookingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LabBooking>(
      row,
      columns: columns?.call(LabBooking.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LabBooking] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LabBooking?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<LabBookingUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<LabBooking>(
      id,
      columnValues: columnValues(LabBooking.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LabBooking]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<LabBooking>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<LabBookingUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LabBookingTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabBookingTable>? orderBy,
    _i1.OrderByListBuilder<LabBookingTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<LabBooking>(
      columnValues: columnValues(LabBooking.t.updateTable),
      where: where(LabBooking.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LabBooking.t),
      orderByList: orderByList?.call(LabBooking.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [LabBooking]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LabBooking>> delete(
    _i1.DatabaseSession session,
    List<LabBooking> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LabBooking>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LabBooking].
  Future<LabBooking> deleteRow(
    _i1.DatabaseSession session,
    LabBooking row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LabBooking>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LabBooking>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LabBookingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LabBooking>(
      where: where(LabBooking.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LabBookingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LabBooking>(
      where: where?.call(LabBooking.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LabBooking] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LabBookingTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LabBooking>(
      where: where(LabBooking.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
