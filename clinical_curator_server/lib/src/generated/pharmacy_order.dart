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

/// Pharmacy medicine order.
abstract class PharmacyOrder
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PharmacyOrder._({
    this.id,
    required this.patientRef,
    required this.pharmacyName,
    required this.itemsJson,
    required this.status,
    required this.totalPrice,
    this.deliveryAddress,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory PharmacyOrder({
    int? id,
    required String patientRef,
    required String pharmacyName,
    required String itemsJson,
    required String status,
    required double totalPrice,
    String? deliveryAddress,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _PharmacyOrderImpl;

  factory PharmacyOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return PharmacyOrder(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      pharmacyName: jsonSerialization['pharmacyName'] as String,
      itemsJson: jsonSerialization['itemsJson'] as String,
      status: jsonSerialization['status'] as String,
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      deliveryAddress: jsonSerialization['deliveryAddress'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = PharmacyOrderTable();

  static const db = PharmacyOrderRepository._();

  @override
  int? id;

  String patientRef;

  String pharmacyName;

  String itemsJson;

  String status;

  double totalPrice;

  String? deliveryAddress;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PharmacyOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PharmacyOrder copyWith({
    int? id,
    String? patientRef,
    String? pharmacyName,
    String? itemsJson,
    String? status,
    double? totalPrice,
    String? deliveryAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PharmacyOrder',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'pharmacyName': pharmacyName,
      'itemsJson': itemsJson,
      'status': status,
      'totalPrice': totalPrice,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PharmacyOrder',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'pharmacyName': pharmacyName,
      'itemsJson': itemsJson,
      'status': status,
      'totalPrice': totalPrice,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static PharmacyOrderInclude include() {
    return PharmacyOrderInclude._();
  }

  static PharmacyOrderIncludeList includeList({
    _i1.WhereExpressionBuilder<PharmacyOrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PharmacyOrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PharmacyOrderTable>? orderByList,
    PharmacyOrderInclude? include,
  }) {
    return PharmacyOrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PharmacyOrder.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PharmacyOrder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PharmacyOrderImpl extends PharmacyOrder {
  _PharmacyOrderImpl({
    int? id,
    required String patientRef,
    required String pharmacyName,
    required String itemsJson,
    required String status,
    required double totalPrice,
    String? deliveryAddress,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         pharmacyName: pharmacyName,
         itemsJson: itemsJson,
         status: status,
         totalPrice: totalPrice,
         deliveryAddress: deliveryAddress,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [PharmacyOrder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PharmacyOrder copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? pharmacyName,
    String? itemsJson,
    String? status,
    double? totalPrice,
    Object? deliveryAddress = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return PharmacyOrder(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      itemsJson: itemsJson ?? this.itemsJson,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryAddress: deliveryAddress is String?
          ? deliveryAddress
          : this.deliveryAddress,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class PharmacyOrderUpdateTable extends _i1.UpdateTable<PharmacyOrderTable> {
  PharmacyOrderUpdateTable(super.table);

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> pharmacyName(String value) => _i1.ColumnValue(
    table.pharmacyName,
    value,
  );

  _i1.ColumnValue<String, String> itemsJson(String value) => _i1.ColumnValue(
    table.itemsJson,
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

  _i1.ColumnValue<String, String> deliveryAddress(String? value) =>
      _i1.ColumnValue(
        table.deliveryAddress,
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

class PharmacyOrderTable extends _i1.Table<int?> {
  PharmacyOrderTable({super.tableRelation})
    : super(tableName: 'pharmacy_orders') {
    updateTable = PharmacyOrderUpdateTable(this);
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    pharmacyName = _i1.ColumnString(
      'pharmacyName',
      this,
    );
    itemsJson = _i1.ColumnString(
      'itemsJson',
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
    deliveryAddress = _i1.ColumnString(
      'deliveryAddress',
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

  late final PharmacyOrderUpdateTable updateTable;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString pharmacyName;

  late final _i1.ColumnString itemsJson;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble totalPrice;

  late final _i1.ColumnString deliveryAddress;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    patientRef,
    pharmacyName,
    itemsJson,
    status,
    totalPrice,
    deliveryAddress,
    notes,
    createdAt,
    updatedAt,
  ];
}

class PharmacyOrderInclude extends _i1.IncludeObject {
  PharmacyOrderInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PharmacyOrder.t;
}

class PharmacyOrderIncludeList extends _i1.IncludeList {
  PharmacyOrderIncludeList._({
    _i1.WhereExpressionBuilder<PharmacyOrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PharmacyOrder.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PharmacyOrder.t;
}

class PharmacyOrderRepository {
  const PharmacyOrderRepository._();

  /// Returns a list of [PharmacyOrder]s matching the given query parameters.
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
  Future<List<PharmacyOrder>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PharmacyOrderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PharmacyOrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PharmacyOrderTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PharmacyOrder>(
      where: where?.call(PharmacyOrder.t),
      orderBy: orderBy?.call(PharmacyOrder.t),
      orderByList: orderByList?.call(PharmacyOrder.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PharmacyOrder] matching the given query parameters.
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
  Future<PharmacyOrder?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PharmacyOrderTable>? where,
    int? offset,
    _i1.OrderByBuilder<PharmacyOrderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PharmacyOrderTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PharmacyOrder>(
      where: where?.call(PharmacyOrder.t),
      orderBy: orderBy?.call(PharmacyOrder.t),
      orderByList: orderByList?.call(PharmacyOrder.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PharmacyOrder] by its [id] or null if no such row exists.
  Future<PharmacyOrder?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PharmacyOrder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PharmacyOrder]s in the list and returns the inserted rows.
  ///
  /// The returned [PharmacyOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PharmacyOrder>> insert(
    _i1.DatabaseSession session,
    List<PharmacyOrder> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PharmacyOrder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PharmacyOrder] and returns the inserted row.
  ///
  /// The returned [PharmacyOrder] will have its `id` field set.
  Future<PharmacyOrder> insertRow(
    _i1.DatabaseSession session,
    PharmacyOrder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PharmacyOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PharmacyOrder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PharmacyOrder>> update(
    _i1.DatabaseSession session,
    List<PharmacyOrder> rows, {
    _i1.ColumnSelections<PharmacyOrderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PharmacyOrder>(
      rows,
      columns: columns?.call(PharmacyOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PharmacyOrder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PharmacyOrder> updateRow(
    _i1.DatabaseSession session,
    PharmacyOrder row, {
    _i1.ColumnSelections<PharmacyOrderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PharmacyOrder>(
      row,
      columns: columns?.call(PharmacyOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PharmacyOrder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PharmacyOrder?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<PharmacyOrderUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PharmacyOrder>(
      id,
      columnValues: columnValues(PharmacyOrder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PharmacyOrder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PharmacyOrder>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PharmacyOrderUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PharmacyOrderTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PharmacyOrderTable>? orderBy,
    _i1.OrderByListBuilder<PharmacyOrderTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PharmacyOrder>(
      columnValues: columnValues(PharmacyOrder.t.updateTable),
      where: where(PharmacyOrder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PharmacyOrder.t),
      orderByList: orderByList?.call(PharmacyOrder.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PharmacyOrder]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PharmacyOrder>> delete(
    _i1.DatabaseSession session,
    List<PharmacyOrder> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PharmacyOrder>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PharmacyOrder].
  Future<PharmacyOrder> deleteRow(
    _i1.DatabaseSession session,
    PharmacyOrder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PharmacyOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PharmacyOrder>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PharmacyOrderTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PharmacyOrder>(
      where: where(PharmacyOrder.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PharmacyOrderTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PharmacyOrder>(
      where: where?.call(PharmacyOrder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PharmacyOrder] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PharmacyOrderTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PharmacyOrder>(
      where: where(PharmacyOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
