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

/// Clinical service request (lab order, imaging, referral).
abstract class ServiceRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ServiceRequest._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.requesterRef,
    this.requesterName,
    required this.code,
    required this.displayName,
    required this.status,
    required this.intent,
    required this.priority,
    this.category,
    this.encounterRef,
    this.occurrenceDate,
    this.performerRef,
    this.reasonJson,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory ServiceRequest({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String code,
    required String displayName,
    required String status,
    required String intent,
    required String priority,
    String? category,
    String? encounterRef,
    DateTime? occurrenceDate,
    String? performerRef,
    String? reasonJson,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _ServiceRequestImpl;

  factory ServiceRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceRequest(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      requesterRef: jsonSerialization['requesterRef'] as String,
      requesterName: jsonSerialization['requesterName'] as String?,
      code: jsonSerialization['code'] as String,
      displayName: jsonSerialization['displayName'] as String,
      status: jsonSerialization['status'] as String,
      intent: jsonSerialization['intent'] as String,
      priority: jsonSerialization['priority'] as String,
      category: jsonSerialization['category'] as String?,
      encounterRef: jsonSerialization['encounterRef'] as String?,
      occurrenceDate: jsonSerialization['occurrenceDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['occurrenceDate'],
            ),
      performerRef: jsonSerialization['performerRef'] as String?,
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

  static final t = ServiceRequestTable();

  static const db = ServiceRequestRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String requesterRef;

  String? requesterName;

  String code;

  String displayName;

  String status;

  String intent;

  String priority;

  String? category;

  String? encounterRef;

  DateTime? occurrenceDate;

  String? performerRef;

  String? reasonJson;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ServiceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServiceRequest copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? requesterRef,
    String? requesterName,
    String? code,
    String? displayName,
    String? status,
    String? intent,
    String? priority,
    String? category,
    String? encounterRef,
    DateTime? occurrenceDate,
    String? performerRef,
    String? reasonJson,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceRequest',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'requesterRef': requesterRef,
      if (requesterName != null) 'requesterName': requesterName,
      'code': code,
      'displayName': displayName,
      'status': status,
      'intent': intent,
      'priority': priority,
      if (category != null) 'category': category,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (occurrenceDate != null) 'occurrenceDate': occurrenceDate?.toJson(),
      if (performerRef != null) 'performerRef': performerRef,
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
      '__className__': 'ServiceRequest',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'requesterRef': requesterRef,
      if (requesterName != null) 'requesterName': requesterName,
      'code': code,
      'displayName': displayName,
      'status': status,
      'intent': intent,
      'priority': priority,
      if (category != null) 'category': category,
      if (encounterRef != null) 'encounterRef': encounterRef,
      if (occurrenceDate != null) 'occurrenceDate': occurrenceDate?.toJson(),
      if (performerRef != null) 'performerRef': performerRef,
      if (reasonJson != null) 'reasonJson': reasonJson,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static ServiceRequestInclude include() {
    return ServiceRequestInclude._();
  }

  static ServiceRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<ServiceRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServiceRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServiceRequestTable>? orderByList,
    ServiceRequestInclude? include,
  }) {
    return ServiceRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServiceRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ServiceRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceRequestImpl extends ServiceRequest {
  _ServiceRequestImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String requesterRef,
    String? requesterName,
    required String code,
    required String displayName,
    required String status,
    required String intent,
    required String priority,
    String? category,
    String? encounterRef,
    DateTime? occurrenceDate,
    String? performerRef,
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
         code: code,
         displayName: displayName,
         status: status,
         intent: intent,
         priority: priority,
         category: category,
         encounterRef: encounterRef,
         occurrenceDate: occurrenceDate,
         performerRef: performerRef,
         reasonJson: reasonJson,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [ServiceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServiceRequest copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? requesterRef,
    Object? requesterName = _Undefined,
    String? code,
    String? displayName,
    String? status,
    String? intent,
    String? priority,
    Object? category = _Undefined,
    Object? encounterRef = _Undefined,
    Object? occurrenceDate = _Undefined,
    Object? performerRef = _Undefined,
    Object? reasonJson = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return ServiceRequest(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      requesterRef: requesterRef ?? this.requesterRef,
      requesterName: requesterName is String?
          ? requesterName
          : this.requesterName,
      code: code ?? this.code,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
      intent: intent ?? this.intent,
      priority: priority ?? this.priority,
      category: category is String? ? category : this.category,
      encounterRef: encounterRef is String? ? encounterRef : this.encounterRef,
      occurrenceDate: occurrenceDate is DateTime?
          ? occurrenceDate
          : this.occurrenceDate,
      performerRef: performerRef is String? ? performerRef : this.performerRef,
      reasonJson: reasonJson is String? ? reasonJson : this.reasonJson,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class ServiceRequestUpdateTable extends _i1.UpdateTable<ServiceRequestTable> {
  ServiceRequestUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
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

  _i1.ColumnValue<String, String> priority(String value) => _i1.ColumnValue(
    table.priority,
    value,
  );

  _i1.ColumnValue<String, String> category(String? value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<String, String> encounterRef(String? value) =>
      _i1.ColumnValue(
        table.encounterRef,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> occurrenceDate(DateTime? value) =>
      _i1.ColumnValue(
        table.occurrenceDate,
        value,
      );

  _i1.ColumnValue<String, String> performerRef(String? value) =>
      _i1.ColumnValue(
        table.performerRef,
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

class ServiceRequestTable extends _i1.Table<int?> {
  ServiceRequestTable({super.tableRelation})
    : super(tableName: 'service_requests') {
    updateTable = ServiceRequestUpdateTable(this);
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
    code = _i1.ColumnString(
      'code',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
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
    priority = _i1.ColumnString(
      'priority',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    encounterRef = _i1.ColumnString(
      'encounterRef',
      this,
    );
    occurrenceDate = _i1.ColumnDateTime(
      'occurrenceDate',
      this,
    );
    performerRef = _i1.ColumnString(
      'performerRef',
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

  late final ServiceRequestUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString requesterRef;

  late final _i1.ColumnString requesterName;

  late final _i1.ColumnString code;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString status;

  late final _i1.ColumnString intent;

  late final _i1.ColumnString priority;

  late final _i1.ColumnString category;

  late final _i1.ColumnString encounterRef;

  late final _i1.ColumnDateTime occurrenceDate;

  late final _i1.ColumnString performerRef;

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
    code,
    displayName,
    status,
    intent,
    priority,
    category,
    encounterRef,
    occurrenceDate,
    performerRef,
    reasonJson,
    notes,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class ServiceRequestInclude extends _i1.IncludeObject {
  ServiceRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ServiceRequest.t;
}

class ServiceRequestIncludeList extends _i1.IncludeList {
  ServiceRequestIncludeList._({
    _i1.WhereExpressionBuilder<ServiceRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServiceRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ServiceRequest.t;
}

class ServiceRequestRepository {
  const ServiceRequestRepository._();

  /// Returns a list of [ServiceRequest]s matching the given query parameters.
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
  Future<List<ServiceRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ServiceRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServiceRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServiceRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ServiceRequest>(
      where: where?.call(ServiceRequest.t),
      orderBy: orderBy?.call(ServiceRequest.t),
      orderByList: orderByList?.call(ServiceRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ServiceRequest] matching the given query parameters.
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
  Future<ServiceRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ServiceRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<ServiceRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ServiceRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ServiceRequest>(
      where: where?.call(ServiceRequest.t),
      orderBy: orderBy?.call(ServiceRequest.t),
      orderByList: orderByList?.call(ServiceRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ServiceRequest] by its [id] or null if no such row exists.
  Future<ServiceRequest?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ServiceRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ServiceRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [ServiceRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ServiceRequest>> insert(
    _i1.DatabaseSession session,
    List<ServiceRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ServiceRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ServiceRequest] and returns the inserted row.
  ///
  /// The returned [ServiceRequest] will have its `id` field set.
  Future<ServiceRequest> insertRow(
    _i1.DatabaseSession session,
    ServiceRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServiceRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ServiceRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ServiceRequest>> update(
    _i1.DatabaseSession session,
    List<ServiceRequest> rows, {
    _i1.ColumnSelections<ServiceRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ServiceRequest>(
      rows,
      columns: columns?.call(ServiceRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServiceRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServiceRequest> updateRow(
    _i1.DatabaseSession session,
    ServiceRequest row, {
    _i1.ColumnSelections<ServiceRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ServiceRequest>(
      row,
      columns: columns?.call(ServiceRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServiceRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ServiceRequest?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ServiceRequestUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ServiceRequest>(
      id,
      columnValues: columnValues(ServiceRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ServiceRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ServiceRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ServiceRequestUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ServiceRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ServiceRequestTable>? orderBy,
    _i1.OrderByListBuilder<ServiceRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ServiceRequest>(
      columnValues: columnValues(ServiceRequest.t.updateTable),
      where: where(ServiceRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServiceRequest.t),
      orderByList: orderByList?.call(ServiceRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ServiceRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ServiceRequest>> delete(
    _i1.DatabaseSession session,
    List<ServiceRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ServiceRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ServiceRequest].
  Future<ServiceRequest> deleteRow(
    _i1.DatabaseSession session,
    ServiceRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServiceRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ServiceRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ServiceRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ServiceRequest>(
      where: where(ServiceRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ServiceRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ServiceRequest>(
      where: where?.call(ServiceRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ServiceRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ServiceRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ServiceRequest>(
      where: where(ServiceRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
