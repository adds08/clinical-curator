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

/// Medication prescription.
abstract class MedicationRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MedicationRequest._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.requesterRef,
    this.requesterName,
    required this.medicationCode,
    required this.medicationName,
    required this.status,
    this.dosageJson,
    this.dispenseJson,
    this.encounterRef,
    this.reasonJson,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory MedicationRequest({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String medicationCode,
    required String medicationName,
    required String status,
    String? dosageJson,
    String? dispenseJson,
    String? encounterRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _MedicationRequestImpl;

  factory MedicationRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return MedicationRequest(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      requesterRef: jsonSerialization['requesterRef'] as String,
      requesterName: jsonSerialization['requesterName'] as String?,
      medicationCode: jsonSerialization['medicationCode'] as String,
      medicationName: jsonSerialization['medicationName'] as String,
      status: jsonSerialization['status'] as String,
      dosageJson: jsonSerialization['dosageJson'] as String?,
      dispenseJson: jsonSerialization['dispenseJson'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      reasonJson: jsonSerialization['reasonJson'] as String?,
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

  static final t = MedicationRequestTable();

  static const db = MedicationRequestRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String requesterRef;

  String? requesterName;

  String medicationCode;

  String medicationName;

  String status;

  String? dosageJson;

  String? dispenseJson;

  String? encounterRef;

  String? reasonJson;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MedicationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MedicationRequest copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? requesterRef,
    String? requesterName,
    String? medicationCode,
    String? medicationName,
    String? status,
    String? dosageJson,
    String? dispenseJson,
    String? encounterRef,
    String? reasonJson,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MedicationRequest',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'requesterRef': requesterRef,
      if (requesterName != null) 'requesterName': requesterName,
      'medicationCode': medicationCode,
      'medicationName': medicationName,
      'status': status,
      if (dosageJson != null) 'dosageJson': dosageJson,
      if (dispenseJson != null) 'dispenseJson': dispenseJson,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MedicationRequest',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'requesterRef': requesterRef,
      if (requesterName != null) 'requesterName': requesterName,
      'medicationCode': medicationCode,
      'medicationName': medicationName,
      'status': status,
      if (dosageJson != null) 'dosageJson': dosageJson,
      if (dispenseJson != null) 'dispenseJson': dispenseJson,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static MedicationRequestInclude include() {
    return MedicationRequestInclude._();
  }

  static MedicationRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<MedicationRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MedicationRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MedicationRequestTable>? orderByList,
    MedicationRequestInclude? include,
  }) {
    return MedicationRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MedicationRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MedicationRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationRequestImpl extends MedicationRequest {
  _MedicationRequestImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String medicationCode,
    required String medicationName,
    required String status,
    String? dosageJson,
    String? dispenseJson,
    String? encounterRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         requesterRef: requesterRef,
         requesterName: requesterName,
         medicationCode: medicationCode,
         medicationName: medicationName,
         status: status,
         dosageJson: dosageJson,
         dispenseJson: dispenseJson,
         encounterRef: encounterRef,
         reasonJson: reasonJson,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [MedicationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MedicationRequest copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? requesterRef,
    Object? requesterName = _Undefined,
    String? medicationCode,
    String? medicationName,
    String? status,
    Object? dosageJson = _Undefined,
    Object? dispenseJson = _Undefined,
    Object? encounterRef = _Undefined,
    Object? reasonJson = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return MedicationRequest(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      requesterRef: requesterRef ?? this.requesterRef,
      requesterName: requesterName is String?
          ? requesterName
          : this.requesterName,
      medicationCode: medicationCode ?? this.medicationCode,
      medicationName: medicationName ?? this.medicationName,
      status: status ?? this.status,
      dosageJson: dosageJson is String? ? dosageJson : this.dosageJson,
      dispenseJson: dispenseJson is String? ? dispenseJson : this.dispenseJson,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      reasonJson: reasonJson is String? ? reasonJson : this.reasonJson,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class MedicationRequestUpdateTable
    extends _i1.UpdateTable<MedicationRequestTable> {
  MedicationRequestUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> requesterRef(String value) => _i1.ColumnValue(
    table.requesterRef,
    value,
  );

  _i1.ColumnValue<String, String> requesterName(String? value) =>
      _i1.ColumnValue(
        table.requesterName,
        value,
      );

  _i1.ColumnValue<String, String> medicationCode(String value) =>
      _i1.ColumnValue(
        table.medicationCode,
        value,
      );

  _i1.ColumnValue<String, String> medicationName(String value) =>
      _i1.ColumnValue(
        table.medicationName,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> dosageJson(String? value) => _i1.ColumnValue(
    table.dosageJson,
    value,
  );

  _i1.ColumnValue<String, String> dispenseJson(String? value) =>
      _i1.ColumnValue(
        table.dispenseJson,
        value,
      );

  _i1.ColumnValue<String, String> encounterRef(String? value) =>
      _i1.ColumnValue(
        table.encounterRef,
        value,
      );

  _i1.ColumnValue<String, String> reasonJson(String? value) => _i1.ColumnValue(
    table.reasonJson,
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

class MedicationRequestTable extends _i1.Table<int?> {
  MedicationRequestTable({super.tableRelation})
    : super(tableName: 'medication_requests') {
    updateTable = MedicationRequestUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    requesterRef = _i1.ColumnString(
      'requesterRef',
      this,
    );
    requesterName = _i1.ColumnString(
      'requesterName',
      this,
    );
    medicationCode = _i1.ColumnString(
      'medicationCode',
      this,
    );
    medicationName = _i1.ColumnString(
      'medicationName',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    dosageJson = _i1.ColumnString(
      'dosageJson',
      this,
    );
    dispenseJson = _i1.ColumnString(
      'dispenseJson',
      this,
    );
    encounterRef = _i1.ColumnString(
      'encounterRef',
      this,
    );
    reasonJson = _i1.ColumnString(
      'reasonJson',
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

  late final MedicationRequestUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString requesterRef;

  late final _i1.ColumnString requesterName;

  late final _i1.ColumnString medicationCode;

  late final _i1.ColumnString medicationName;

  late final _i1.ColumnString status;

  late final _i1.ColumnString dosageJson;

  late final _i1.ColumnString dispenseJson;

  late final _i1.ColumnString encounterRef;

  late final _i1.ColumnString reasonJson;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    requesterRef,
    requesterName,
    medicationCode,
    medicationName,
    status,
    dosageJson,
    dispenseJson,
    encounterRef,
    reasonJson,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class MedicationRequestInclude extends _i1.IncludeObject {
  MedicationRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MedicationRequest.t;
}

class MedicationRequestIncludeList extends _i1.IncludeList {
  MedicationRequestIncludeList._({
    _i1.WhereExpressionBuilder<MedicationRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MedicationRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MedicationRequest.t;
}

class MedicationRequestRepository {
  const MedicationRequestRepository._();

  /// Returns a list of [MedicationRequest]s matching the given query parameters.
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
  Future<List<MedicationRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MedicationRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MedicationRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MedicationRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MedicationRequest>(
      where: where?.call(MedicationRequest.t),
      orderBy: orderBy?.call(MedicationRequest.t),
      orderByList: orderByList?.call(MedicationRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MedicationRequest] matching the given query parameters.
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
  Future<MedicationRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MedicationRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<MedicationRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MedicationRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MedicationRequest>(
      where: where?.call(MedicationRequest.t),
      orderBy: orderBy?.call(MedicationRequest.t),
      orderByList: orderByList?.call(MedicationRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MedicationRequest] by its [id] or null if no such row exists.
  Future<MedicationRequest?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MedicationRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MedicationRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [MedicationRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<MedicationRequest>> insert(
    _i1.DatabaseSession session,
    List<MedicationRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<MedicationRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [MedicationRequest] and returns the inserted row.
  ///
  /// The returned [MedicationRequest] will have its `id` field set.
  Future<MedicationRequest> insertRow(
    _i1.DatabaseSession session,
    MedicationRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MedicationRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MedicationRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MedicationRequest>> update(
    _i1.DatabaseSession session,
    List<MedicationRequest> rows, {
    _i1.ColumnSelections<MedicationRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MedicationRequest>(
      rows,
      columns: columns?.call(MedicationRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MedicationRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MedicationRequest> updateRow(
    _i1.DatabaseSession session,
    MedicationRequest row, {
    _i1.ColumnSelections<MedicationRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MedicationRequest>(
      row,
      columns: columns?.call(MedicationRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MedicationRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MedicationRequest?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<MedicationRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<MedicationRequest>(
      id,
      columnValues: columnValues(MedicationRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MedicationRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<MedicationRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<MedicationRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<MedicationRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MedicationRequestTable>? orderBy,
    _i1.OrderByListBuilder<MedicationRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<MedicationRequest>(
      columnValues: columnValues(MedicationRequest.t.updateTable),
      where: where(MedicationRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MedicationRequest.t),
      orderByList: orderByList?.call(MedicationRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [MedicationRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MedicationRequest>> delete(
    _i1.DatabaseSession session,
    List<MedicationRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MedicationRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MedicationRequest].
  Future<MedicationRequest> deleteRow(
    _i1.DatabaseSession session,
    MedicationRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MedicationRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MedicationRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MedicationRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MedicationRequest>(
      where: where(MedicationRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<MedicationRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MedicationRequest>(
      where: where?.call(MedicationRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MedicationRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<MedicationRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MedicationRequest>(
      where: where(MedicationRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
