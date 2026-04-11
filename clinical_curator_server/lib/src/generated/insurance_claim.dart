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

/// Insurance claim submission.
abstract class InsuranceClaim
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  InsuranceClaim._({
    this.id,
    required this.patientRef,
    required this.claimType,
    required this.provider,
    required this.policyNumber,
    required this.amount,
    required this.status,
    this.description,
    this.documentsJson,
    required this.createdAt,
    this.updatedAt,
  });

  factory InsuranceClaim({
    int? id,
    required String patientRef,
    required String claimType,
    required String provider,
    required String policyNumber,
    required double amount,
    required String status,
    String? description,
    String? documentsJson,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _InsuranceClaimImpl;

  factory InsuranceClaim.fromJson(Map<String, dynamic> jsonSerialization) {
    return InsuranceClaim(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      claimType: jsonSerialization['claimType'] as String,
      provider: jsonSerialization['provider'] as String,
      policyNumber: jsonSerialization['policyNumber'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      description: jsonSerialization['description'] as String?,
      documentsJson: jsonSerialization['documentsJson'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = InsuranceClaimTable();

  static const db = InsuranceClaimRepository._();

  @override
  int? id;

  String patientRef;

  String claimType;

  String provider;

  String policyNumber;

  double amount;

  String status;

  String? description;

  String? documentsJson;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [InsuranceClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InsuranceClaim copyWith({
    int? id,
    String? patientRef,
    String? claimType,
    String? provider,
    String? policyNumber,
    double? amount,
    String? status,
    String? description,
    String? documentsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InsuranceClaim',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'claimType': claimType,
      'provider': provider,
      'policyNumber': policyNumber,
      'amount': amount,
      'status': status,
      if (description != null) 'description': description,
      if (documentsJson != null) 'documentsJson': documentsJson,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InsuranceClaim',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'claimType': claimType,
      'provider': provider,
      'policyNumber': policyNumber,
      'amount': amount,
      'status': status,
      if (description != null) 'description': description,
      if (documentsJson != null) 'documentsJson': documentsJson,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static InsuranceClaimInclude include() {
    return InsuranceClaimInclude._();
  }

  static InsuranceClaimIncludeList includeList({
    _i1.WhereExpressionBuilder<InsuranceClaimTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InsuranceClaimTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InsuranceClaimTable>? orderByList,
    InsuranceClaimInclude? include,
  }) {
    return InsuranceClaimIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InsuranceClaim.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(InsuranceClaim.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InsuranceClaimImpl extends InsuranceClaim {
  _InsuranceClaimImpl({
    int? id,
    required String patientRef,
    required String claimType,
    required String provider,
    required String policyNumber,
    required double amount,
    required String status,
    String? description,
    String? documentsJson,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         claimType: claimType,
         provider: provider,
         policyNumber: policyNumber,
         amount: amount,
         status: status,
         description: description,
         documentsJson: documentsJson,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [InsuranceClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InsuranceClaim copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? claimType,
    String? provider,
    String? policyNumber,
    double? amount,
    String? status,
    Object? description = _Undefined,
    Object? documentsJson = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return InsuranceClaim(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      claimType: claimType ?? this.claimType,
      provider: provider ?? this.provider,
      policyNumber: policyNumber ?? this.policyNumber,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description is String? ? description : this.description,
      documentsJson: documentsJson is String?
          ? documentsJson
          : this.documentsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class InsuranceClaimUpdateTable extends _i1.UpdateTable<InsuranceClaimTable> {
  InsuranceClaimUpdateTable(super.table);

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> claimType(String value) => _i1.ColumnValue(
    table.claimType,
    value,
  );

  _i1.ColumnValue<String, String> provider(String value) => _i1.ColumnValue(
    table.provider,
    value,
  );

  _i1.ColumnValue<String, String> policyNumber(String value) => _i1.ColumnValue(
    table.policyNumber,
    value,
  );

  _i1.ColumnValue<double, double> amount(double value) => _i1.ColumnValue(
    table.amount,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> documentsJson(String? value) =>
      _i1.ColumnValue(
        table.documentsJson,
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

class InsuranceClaimTable extends _i1.Table<int?> {
  InsuranceClaimTable({super.tableRelation})
    : super(tableName: 'insurance_claims') {
    updateTable = InsuranceClaimUpdateTable(this);
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    claimType = _i1.ColumnString(
      'claimType',
      this,
    );
    provider = _i1.ColumnString(
      'provider',
      this,
    );
    policyNumber = _i1.ColumnString(
      'policyNumber',
      this,
    );
    amount = _i1.ColumnDouble(
      'amount',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    documentsJson = _i1.ColumnString(
      'documentsJson',
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

  late final InsuranceClaimUpdateTable updateTable;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString claimType;

  late final _i1.ColumnString provider;

  late final _i1.ColumnString policyNumber;

  late final _i1.ColumnDouble amount;

  late final _i1.ColumnString status;

  late final _i1.ColumnString description;

  late final _i1.ColumnString documentsJson;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    patientRef,
    claimType,
    provider,
    policyNumber,
    amount,
    status,
    description,
    documentsJson,
    createdAt,
    updatedAt,
  ];
}

class InsuranceClaimInclude extends _i1.IncludeObject {
  InsuranceClaimInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => InsuranceClaim.t;
}

class InsuranceClaimIncludeList extends _i1.IncludeList {
  InsuranceClaimIncludeList._({
    _i1.WhereExpressionBuilder<InsuranceClaimTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InsuranceClaim.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => InsuranceClaim.t;
}

class InsuranceClaimRepository {
  const InsuranceClaimRepository._();

  /// Returns a list of [InsuranceClaim]s matching the given query parameters.
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
  Future<List<InsuranceClaim>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InsuranceClaimTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InsuranceClaimTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InsuranceClaimTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InsuranceClaim>(
      where: where?.call(InsuranceClaim.t),
      orderBy: orderBy?.call(InsuranceClaim.t),
      orderByList: orderByList?.call(InsuranceClaim.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InsuranceClaim] matching the given query parameters.
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
  Future<InsuranceClaim?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InsuranceClaimTable>? where,
    int? offset,
    _i1.OrderByBuilder<InsuranceClaimTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InsuranceClaimTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InsuranceClaim>(
      where: where?.call(InsuranceClaim.t),
      orderBy: orderBy?.call(InsuranceClaim.t),
      orderByList: orderByList?.call(InsuranceClaim.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InsuranceClaim] by its [id] or null if no such row exists.
  Future<InsuranceClaim?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InsuranceClaim>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InsuranceClaim]s in the list and returns the inserted rows.
  ///
  /// The returned [InsuranceClaim]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<InsuranceClaim>> insert(
    _i1.DatabaseSession session,
    List<InsuranceClaim> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<InsuranceClaim>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [InsuranceClaim] and returns the inserted row.
  ///
  /// The returned [InsuranceClaim] will have its `id` field set.
  Future<InsuranceClaim> insertRow(
    _i1.DatabaseSession session,
    InsuranceClaim row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<InsuranceClaim>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [InsuranceClaim]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<InsuranceClaim>> update(
    _i1.DatabaseSession session,
    List<InsuranceClaim> rows, {
    _i1.ColumnSelections<InsuranceClaimTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<InsuranceClaim>(
      rows,
      columns: columns?.call(InsuranceClaim.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InsuranceClaim]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InsuranceClaim> updateRow(
    _i1.DatabaseSession session,
    InsuranceClaim row, {
    _i1.ColumnSelections<InsuranceClaimTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<InsuranceClaim>(
      row,
      columns: columns?.call(InsuranceClaim.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InsuranceClaim] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InsuranceClaim?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<InsuranceClaimUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<InsuranceClaim>(
      id,
      columnValues: columnValues(InsuranceClaim.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InsuranceClaim]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<InsuranceClaim>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<InsuranceClaimUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<InsuranceClaimTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InsuranceClaimTable>? orderBy,
    _i1.OrderByListBuilder<InsuranceClaimTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<InsuranceClaim>(
      columnValues: columnValues(InsuranceClaim.t.updateTable),
      where: where(InsuranceClaim.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InsuranceClaim.t),
      orderByList: orderByList?.call(InsuranceClaim.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [InsuranceClaim]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<InsuranceClaim>> delete(
    _i1.DatabaseSession session,
    List<InsuranceClaim> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<InsuranceClaim>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [InsuranceClaim].
  Future<InsuranceClaim> deleteRow(
    _i1.DatabaseSession session,
    InsuranceClaim row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InsuranceClaim>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<InsuranceClaim>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InsuranceClaimTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<InsuranceClaim>(
      where: where(InsuranceClaim.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InsuranceClaimTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<InsuranceClaim>(
      where: where?.call(InsuranceClaim.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InsuranceClaim] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InsuranceClaimTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InsuranceClaim>(
      where: where(InsuranceClaim.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
