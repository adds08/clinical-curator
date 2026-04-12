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

/// Patient immunization record.
abstract class Immunization
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Immunization._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.vaccineCode,
    required this.vaccineName,
    required this.occurrenceDate,
    required this.status,
    this.lotNumber,
    this.site,
    this.routeOfAdmin,
    this.doseQuantity,
    this.performerRef,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Immunization({
    int? id,
    String? fhirId,
    required String patientRef,
    required String vaccineCode,
    required String vaccineName,
    required DateTime occurrenceDate,
    required String status,
    String? lotNumber,
    String? site,
    String? routeOfAdmin,
    String? doseQuantity,
    String? performerRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ImmunizationImpl;

  factory Immunization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Immunization(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      vaccineCode: jsonSerialization['vaccineCode'] as String,
      vaccineName: jsonSerialization['vaccineName'] as String,
      occurrenceDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurrenceDate'],
      ),
      status: jsonSerialization['status'] as String,
      lotNumber: jsonSerialization['lotNumber'] as String?,
      site: jsonSerialization['site'] as String?,
      routeOfAdmin: jsonSerialization['routeOfAdmin'] as String?,
      doseQuantity: jsonSerialization['doseQuantity'] as String?,
      performerRef: jsonSerialization['performerRef'] as String?,
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

  static final t = ImmunizationTable();

  static const db = ImmunizationRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String vaccineCode;

  String vaccineName;

  DateTime occurrenceDate;

  String status;

  String? lotNumber;

  String? site;

  String? routeOfAdmin;

  String? doseQuantity;

  String? performerRef;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Immunization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Immunization copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? vaccineCode,
    String? vaccineName,
    DateTime? occurrenceDate,
    String? status,
    String? lotNumber,
    String? site,
    String? routeOfAdmin,
    String? doseQuantity,
    String? performerRef,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Immunization',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'vaccineCode': vaccineCode,
      'vaccineName': vaccineName,
      'occurrenceDate': occurrenceDate.toJson(),
      'status': status,
      if (lotNumber != null) 'lotNumber': lotNumber,
      if (site != null) 'site': site,
      if (routeOfAdmin != null) 'routeOfAdmin': routeOfAdmin,
      if (doseQuantity != null) 'doseQuantity': doseQuantity,
      if (performerRef != null) 'performerRef': performerRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Immunization',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'vaccineCode': vaccineCode,
      'vaccineName': vaccineName,
      'occurrenceDate': occurrenceDate.toJson(),
      'status': status,
      if (lotNumber != null) 'lotNumber': lotNumber,
      if (site != null) 'site': site,
      if (routeOfAdmin != null) 'routeOfAdmin': routeOfAdmin,
      if (doseQuantity != null) 'doseQuantity': doseQuantity,
      if (performerRef != null) 'performerRef': performerRef,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static ImmunizationInclude include() {
    return ImmunizationInclude._();
  }

  static ImmunizationIncludeList includeList({
    _i1.WhereExpressionBuilder<ImmunizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImmunizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImmunizationTable>? orderByList,
    ImmunizationInclude? include,
  }) {
    return ImmunizationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Immunization.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Immunization.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImmunizationImpl extends Immunization {
  _ImmunizationImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String vaccineCode,
    required String vaccineName,
    required DateTime occurrenceDate,
    required String status,
    String? lotNumber,
    String? site,
    String? routeOfAdmin,
    String? doseQuantity,
    String? performerRef,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         vaccineCode: vaccineCode,
         vaccineName: vaccineName,
         occurrenceDate: occurrenceDate,
         status: status,
         lotNumber: lotNumber,
         site: site,
         routeOfAdmin: routeOfAdmin,
         doseQuantity: doseQuantity,
         performerRef: performerRef,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Immunization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Immunization copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? vaccineCode,
    String? vaccineName,
    DateTime? occurrenceDate,
    String? status,
    Object? lotNumber = _Undefined,
    Object? site = _Undefined,
    Object? routeOfAdmin = _Undefined,
    Object? doseQuantity = _Undefined,
    Object? performerRef = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Immunization(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      vaccineCode: vaccineCode ?? this.vaccineCode,
      vaccineName: vaccineName ?? this.vaccineName,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      status: status ?? this.status,
      lotNumber: lotNumber is String? ? lotNumber : this.lotNumber,
      site: site is String? ? site : this.site,
      routeOfAdmin: routeOfAdmin is String? ? routeOfAdmin : this.routeOfAdmin,
      doseQuantity: doseQuantity is String? ? doseQuantity : this.doseQuantity,
      performerRef: performerRef is String? ? performerRef : this.performerRef,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class ImmunizationUpdateTable extends _i1.UpdateTable<ImmunizationTable> {
  ImmunizationUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> vaccineCode(String value) => _i1.ColumnValue(
    table.vaccineCode,
    value,
  );

  _i1.ColumnValue<String, String> vaccineName(String value) => _i1.ColumnValue(
    table.vaccineName,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> occurrenceDate(DateTime value) =>
      _i1.ColumnValue(
        table.occurrenceDate,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> lotNumber(String? value) => _i1.ColumnValue(
    table.lotNumber,
    value,
  );

  _i1.ColumnValue<String, String> site(String? value) => _i1.ColumnValue(
    table.site,
    value,
  );

  _i1.ColumnValue<String, String> routeOfAdmin(String? value) =>
      _i1.ColumnValue(
        table.routeOfAdmin,
        value,
      );

  _i1.ColumnValue<String, String> doseQuantity(String? value) =>
      _i1.ColumnValue(
        table.doseQuantity,
        value,
      );

  _i1.ColumnValue<String, String> performerRef(String? value) =>
      _i1.ColumnValue(
        table.performerRef,
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

class ImmunizationTable extends _i1.Table<int?> {
  ImmunizationTable({super.tableRelation}) : super(tableName: 'immunizations') {
    updateTable = ImmunizationUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    vaccineCode = _i1.ColumnString(
      'vaccineCode',
      this,
    );
    vaccineName = _i1.ColumnString(
      'vaccineName',
      this,
    );
    occurrenceDate = _i1.ColumnDateTime(
      'occurrenceDate',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    lotNumber = _i1.ColumnString(
      'lotNumber',
      this,
    );
    site = _i1.ColumnString(
      'site',
      this,
    );
    routeOfAdmin = _i1.ColumnString(
      'routeOfAdmin',
      this,
    );
    doseQuantity = _i1.ColumnString(
      'doseQuantity',
      this,
    );
    performerRef = _i1.ColumnString(
      'performerRef',
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

  late final ImmunizationUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString vaccineCode;

  late final _i1.ColumnString vaccineName;

  late final _i1.ColumnDateTime occurrenceDate;

  late final _i1.ColumnString status;

  late final _i1.ColumnString lotNumber;

  late final _i1.ColumnString site;

  late final _i1.ColumnString routeOfAdmin;

  late final _i1.ColumnString doseQuantity;

  late final _i1.ColumnString performerRef;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    vaccineCode,
    vaccineName,
    occurrenceDate,
    status,
    lotNumber,
    site,
    routeOfAdmin,
    doseQuantity,
    performerRef,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class ImmunizationInclude extends _i1.IncludeObject {
  ImmunizationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Immunization.t;
}

class ImmunizationIncludeList extends _i1.IncludeList {
  ImmunizationIncludeList._({
    _i1.WhereExpressionBuilder<ImmunizationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Immunization.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Immunization.t;
}

class ImmunizationRepository {
  const ImmunizationRepository._();

  /// Returns a list of [Immunization]s matching the given query parameters.
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
  Future<List<Immunization>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ImmunizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImmunizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImmunizationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Immunization>(
      where: where?.call(Immunization.t),
      orderBy: orderBy?.call(Immunization.t),
      orderByList: orderByList?.call(Immunization.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Immunization] matching the given query parameters.
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
  Future<Immunization?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ImmunizationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ImmunizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImmunizationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Immunization>(
      where: where?.call(Immunization.t),
      orderBy: orderBy?.call(Immunization.t),
      orderByList: orderByList?.call(Immunization.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Immunization] by its [id] or null if no such row exists.
  Future<Immunization?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Immunization>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Immunization]s in the list and returns the inserted rows.
  ///
  /// The returned [Immunization]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Immunization>> insert(
    _i1.DatabaseSession session,
    List<Immunization> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Immunization>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Immunization] and returns the inserted row.
  ///
  /// The returned [Immunization] will have its `id` field set.
  Future<Immunization> insertRow(
    _i1.DatabaseSession session,
    Immunization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Immunization>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Immunization]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Immunization>> update(
    _i1.DatabaseSession session,
    List<Immunization> rows, {
    _i1.ColumnSelections<ImmunizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Immunization>(
      rows,
      columns: columns?.call(Immunization.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Immunization]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Immunization> updateRow(
    _i1.DatabaseSession session,
    Immunization row, {
    _i1.ColumnSelections<ImmunizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Immunization>(
      row,
      columns: columns?.call(Immunization.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Immunization] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Immunization?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ImmunizationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Immunization>(
      id,
      columnValues: columnValues(Immunization.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Immunization]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Immunization>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ImmunizationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ImmunizationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImmunizationTable>? orderBy,
    _i1.OrderByListBuilder<ImmunizationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Immunization>(
      columnValues: columnValues(Immunization.t.updateTable),
      where: where(Immunization.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Immunization.t),
      orderByList: orderByList?.call(Immunization.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Immunization]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Immunization>> delete(
    _i1.DatabaseSession session,
    List<Immunization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Immunization>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Immunization].
  Future<Immunization> deleteRow(
    _i1.DatabaseSession session,
    Immunization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Immunization>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Immunization>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ImmunizationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Immunization>(
      where: where(Immunization.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ImmunizationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Immunization>(
      where: where?.call(Immunization.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Immunization] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ImmunizationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Immunization>(
      where: where(Immunization.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
