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

/// Medical appointment (telemedicine or in-person).
abstract class Appointment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Appointment._({
    this.id,
    this.fhirId,
    required this.patientRef,
    required this.practitionerRef,
    required this.practitionerName,
    required this.patientName,
    required this.appointmentType,
    required this.status,
    required this.scheduledAt,
    required this.durationMinutes,
    this.specialty,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Appointment({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String practitionerName,
    required String patientName,
    required String appointmentType,
    required String status,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? specialty,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AppointmentImpl;

  factory Appointment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Appointment(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      patientRef: jsonSerialization['patientRef'] as String,
      practitionerRef: jsonSerialization['practitionerRef'] as String,
      practitionerName: jsonSerialization['practitionerName'] as String,
      patientName: jsonSerialization['patientName'] as String,
      appointmentType: jsonSerialization['appointmentType'] as String,
      status: jsonSerialization['status'] as String,
      scheduledAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledAt'],
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      specialty: jsonSerialization['specialty'] as String?,
      notes: jsonSerialization['notes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AppointmentTable();

  static const db = AppointmentRepository._();

  @override
  int? id;

  String? fhirId;

  String patientRef;

  String practitionerRef;

  String practitionerName;

  String patientName;

  String appointmentType;

  String status;

  DateTime scheduledAt;

  int durationMinutes;

  String? specialty;

  String? notes;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Appointment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Appointment copyWith({
    int? id,
    String? fhirId,
    String? patientRef,
    String? practitionerRef,
    String? practitionerName,
    String? patientName,
    String? appointmentType,
    String? status,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? specialty,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Appointment',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'practitionerRef': practitionerRef,
      'practitionerName': practitionerName,
      'patientName': patientName,
      'appointmentType': appointmentType,
      'status': status,
      'scheduledAt': scheduledAt.toJson(),
      'durationMinutes': durationMinutes,
      if (specialty != null) 'specialty': specialty,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Appointment',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'patientRef': patientRef,
      'practitionerRef': practitionerRef,
      'practitionerName': practitionerName,
      'patientName': patientName,
      'appointmentType': appointmentType,
      'status': status,
      'scheduledAt': scheduledAt.toJson(),
      'durationMinutes': durationMinutes,
      if (specialty != null) 'specialty': specialty,
      if (notes != null) 'notes': notes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static AppointmentInclude include() {
    return AppointmentInclude._();
  }

  static AppointmentIncludeList includeList({
    _i1.WhereExpressionBuilder<AppointmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppointmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppointmentTable>? orderByList,
    AppointmentInclude? include,
  }) {
    return AppointmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Appointment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Appointment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppointmentImpl extends Appointment {
  _AppointmentImpl({
    int? id,
    String? fhirId,
    required String patientRef,
    required String practitionerRef,
    required String practitionerName,
    required String patientName,
    required String appointmentType,
    required String status,
    required DateTime scheduledAt,
    required int durationMinutes,
    String? specialty,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         fhirId: fhirId,
         patientRef: patientRef,
         practitionerRef: practitionerRef,
         practitionerName: practitionerName,
         patientName: patientName,
         appointmentType: appointmentType,
         status: status,
         scheduledAt: scheduledAt,
         durationMinutes: durationMinutes,
         specialty: specialty,
         notes: notes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Appointment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Appointment copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? patientRef,
    String? practitionerRef,
    String? practitionerName,
    String? patientName,
    String? appointmentType,
    String? status,
    DateTime? scheduledAt,
    int? durationMinutes,
    Object? specialty = _Undefined,
    Object? notes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return Appointment(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      patientRef: patientRef ?? this.patientRef,
      practitionerRef: practitionerRef ?? this.practitionerRef,
      practitionerName: practitionerName ?? this.practitionerName,
      patientName: patientName ?? this.patientName,
      appointmentType: appointmentType ?? this.appointmentType,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      specialty: specialty is String? ? specialty : this.specialty,
      notes: notes is String? ? notes : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class AppointmentUpdateTable extends _i1.UpdateTable<AppointmentTable> {
  AppointmentUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> practitionerRef(String value) =>
      _i1.ColumnValue(
        table.practitionerRef,
        value,
      );

  _i1.ColumnValue<String, String> practitionerName(String value) =>
      _i1.ColumnValue(
        table.practitionerName,
        value,
      );

  _i1.ColumnValue<String, String> patientName(String value) => _i1.ColumnValue(
    table.patientName,
    value,
  );

  _i1.ColumnValue<String, String> appointmentType(String value) =>
      _i1.ColumnValue(
        table.appointmentType,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduledAt(DateTime value) =>
      _i1.ColumnValue(
        table.scheduledAt,
        value,
      );

  _i1.ColumnValue<int, int> durationMinutes(int value) => _i1.ColumnValue(
    table.durationMinutes,
    value,
  );

  _i1.ColumnValue<String, String> specialty(String? value) => _i1.ColumnValue(
    table.specialty,
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

class AppointmentTable extends _i1.Table<int?> {
  AppointmentTable({super.tableRelation}) : super(tableName: 'appointments') {
    updateTable = AppointmentUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    practitionerRef = _i1.ColumnString(
      'practitionerRef',
      this,
    );
    practitionerName = _i1.ColumnString(
      'practitionerName',
      this,
    );
    patientName = _i1.ColumnString(
      'patientName',
      this,
    );
    appointmentType = _i1.ColumnString(
      'appointmentType',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    scheduledAt = _i1.ColumnDateTime(
      'scheduledAt',
      this,
    );
    durationMinutes = _i1.ColumnInt(
      'durationMinutes',
      this,
    );
    specialty = _i1.ColumnString(
      'specialty',
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

  late final AppointmentUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString practitionerRef;

  late final _i1.ColumnString practitionerName;

  late final _i1.ColumnString patientName;

  late final _i1.ColumnString appointmentType;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime scheduledAt;

  late final _i1.ColumnInt durationMinutes;

  late final _i1.ColumnString specialty;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    patientRef,
    practitionerRef,
    practitionerName,
    patientName,
    appointmentType,
    status,
    scheduledAt,
    durationMinutes,
    specialty,
    notes,
    createdAt,
    updatedAt,
  ];
}

class AppointmentInclude extends _i1.IncludeObject {
  AppointmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Appointment.t;
}

class AppointmentIncludeList extends _i1.IncludeList {
  AppointmentIncludeList._({
    _i1.WhereExpressionBuilder<AppointmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Appointment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Appointment.t;
}

class AppointmentRepository {
  const AppointmentRepository._();

  /// Returns a list of [Appointment]s matching the given query parameters.
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
  Future<List<Appointment>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppointmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppointmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppointmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Appointment>(
      where: where?.call(Appointment.t),
      orderBy: orderBy?.call(Appointment.t),
      orderByList: orderByList?.call(Appointment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Appointment] matching the given query parameters.
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
  Future<Appointment?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppointmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppointmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppointmentTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Appointment>(
      where: where?.call(Appointment.t),
      orderBy: orderBy?.call(Appointment.t),
      orderByList: orderByList?.call(Appointment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Appointment] by its [id] or null if no such row exists.
  Future<Appointment?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Appointment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Appointment]s in the list and returns the inserted rows.
  ///
  /// The returned [Appointment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Appointment>> insert(
    _i1.DatabaseSession session,
    List<Appointment> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Appointment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Appointment] and returns the inserted row.
  ///
  /// The returned [Appointment] will have its `id` field set.
  Future<Appointment> insertRow(
    _i1.DatabaseSession session,
    Appointment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Appointment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Appointment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Appointment>> update(
    _i1.DatabaseSession session,
    List<Appointment> rows, {
    _i1.ColumnSelections<AppointmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Appointment>(
      rows,
      columns: columns?.call(Appointment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Appointment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Appointment> updateRow(
    _i1.DatabaseSession session,
    Appointment row, {
    _i1.ColumnSelections<AppointmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Appointment>(
      row,
      columns: columns?.call(Appointment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Appointment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Appointment?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AppointmentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Appointment>(
      id,
      columnValues: columnValues(Appointment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Appointment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Appointment>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AppointmentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppointmentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppointmentTable>? orderBy,
    _i1.OrderByListBuilder<AppointmentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Appointment>(
      columnValues: columnValues(Appointment.t.updateTable),
      where: where(Appointment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Appointment.t),
      orderByList: orderByList?.call(Appointment.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Appointment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Appointment>> delete(
    _i1.DatabaseSession session,
    List<Appointment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Appointment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Appointment].
  Future<Appointment> deleteRow(
    _i1.DatabaseSession session,
    Appointment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Appointment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Appointment>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppointmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Appointment>(
      where: where(Appointment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppointmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Appointment>(
      where: where?.call(Appointment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Appointment] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppointmentTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Appointment>(
      where: where(Appointment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
