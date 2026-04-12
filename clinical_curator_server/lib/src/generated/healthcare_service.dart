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

/// Healthcare service offered by an organization.
abstract class HealthcareService
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  HealthcareService._({
    this.id,
    this.fhirId,
    required this.organizationRef,
    required this.name,
    required this.type,
    this.specialty,
    this.availableTimeJson,
    this.locationRef,
    required this.active,
    this.comment,
    this.telecom,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory HealthcareService({
    int? id,
    String? fhirId,
    required String organizationRef,
    required String name,
    required String type,
    String? specialty,
    String? availableTimeJson,
    String? locationRef,
    required bool active,
    String? comment,
    String? telecom,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _HealthcareServiceImpl;

  factory HealthcareService.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthcareService(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      organizationRef: jsonSerialization['organizationRef'] as String,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      specialty: jsonSerialization['specialty'] as String?,
      availableTimeJson: jsonSerialization['availableTimeJson'] as String?,
      locationRef: jsonSerialization['locationRef'] as String?,
      active: _i1.BoolJsonExtension.fromJson(jsonSerialization['active']),
      comment: jsonSerialization['comment'] as String?,
      telecom: jsonSerialization['telecom'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  static final t = HealthcareServiceTable();

  static const db = HealthcareServiceRepository._();

  @override
  int? id;

  String? fhirId;

  String organizationRef;

  String name;

  String type;

  String? specialty;

  String? availableTimeJson;

  String? locationRef;

  bool active;

  String? comment;

  String? telecom;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [HealthcareService]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HealthcareService copyWith({
    int? id,
    String? fhirId,
    String? organizationRef,
    String? name,
    String? type,
    String? specialty,
    String? availableTimeJson,
    String? locationRef,
    bool? active,
    String? comment,
    String? telecom,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthcareService',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'organizationRef': organizationRef,
      'name': name,
      'type': type,
      if (specialty != null) 'specialty': specialty,
      if (availableTimeJson != null) 'availableTimeJson': availableTimeJson,
      if (locationRef != null) 'locationRef': locationRef,
      'active': active,
      if (comment != null) 'comment': comment,
      if (telecom != null) 'telecom': telecom,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthcareService',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'organizationRef': organizationRef,
      'name': name,
      'type': type,
      if (specialty != null) 'specialty': specialty,
      if (availableTimeJson != null) 'availableTimeJson': availableTimeJson,
      if (locationRef != null) 'locationRef': locationRef,
      'active': active,
      if (comment != null) 'comment': comment,
      if (telecom != null) 'telecom': telecom,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static HealthcareServiceInclude include() {
    return HealthcareServiceInclude._();
  }

  static HealthcareServiceIncludeList includeList({
    _i1.WhereExpressionBuilder<HealthcareServiceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HealthcareServiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HealthcareServiceTable>? orderByList,
    HealthcareServiceInclude? include,
  }) {
    return HealthcareServiceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthcareService.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HealthcareService.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthcareServiceImpl extends HealthcareService {
  _HealthcareServiceImpl({
    int? id,
    String? fhirId,
    required String organizationRef,
    required String name,
    required String type,
    String? specialty,
    String? availableTimeJson,
    String? locationRef,
    required bool active,
    String? comment,
    String? telecom,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         organizationRef: organizationRef,
         name: name,
         type: type,
         specialty: specialty,
         availableTimeJson: availableTimeJson,
         locationRef: locationRef,
         active: active,
         comment: comment,
         telecom: telecom,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [HealthcareService]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HealthcareService copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? organizationRef,
    String? name,
    String? type,
    Object? specialty = _Undefined,
    Object? availableTimeJson = _Undefined,
    Object? locationRef = _Undefined,
    bool? active,
    Object? comment = _Undefined,
    Object? telecom = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return HealthcareService(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      organizationRef: organizationRef ?? this.organizationRef,
      name: name ?? this.name,
      type: type ?? this.type,
      specialty: specialty is String? ? specialty : this.specialty,
      availableTimeJson: availableTimeJson is String?
          ? availableTimeJson
          : this.availableTimeJson,
      locationRef: locationRef is String? ? locationRef : this.locationRef,
      active: active ?? this.active,
      comment: comment is String? ? comment : this.comment,
      telecom: telecom is String? ? telecom : this.telecom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class HealthcareServiceUpdateTable
    extends _i1.UpdateTable<HealthcareServiceTable> {
  HealthcareServiceUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
    value,
  );

  _i1.ColumnValue<String, String> organizationRef(String value) =>
      _i1.ColumnValue(
        table.organizationRef,
        value,
      );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> specialty(String? value) => _i1.ColumnValue(
    table.specialty,
    value,
  );

  _i1.ColumnValue<String, String> availableTimeJson(String? value) =>
      _i1.ColumnValue(
        table.availableTimeJson,
        value,
      );

  _i1.ColumnValue<String, String> locationRef(String? value) => _i1.ColumnValue(
    table.locationRef,
    value,
  );

  _i1.ColumnValue<bool, bool> active(bool value) => _i1.ColumnValue(
    table.active,
    value,
  );

  _i1.ColumnValue<String, String> comment(String? value) => _i1.ColumnValue(
    table.comment,
    value,
  );

  _i1.ColumnValue<String, String> telecom(String? value) => _i1.ColumnValue(
    table.telecom,
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

class HealthcareServiceTable extends _i1.Table<int?> {
  HealthcareServiceTable({super.tableRelation})
    : super(tableName: 'healthcare_services') {
    updateTable = HealthcareServiceUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
      this,
    );
    organizationRef = _i1.ColumnString(
      'organizationRef',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    specialty = _i1.ColumnString(
      'specialty',
      this,
    );
    availableTimeJson = _i1.ColumnString(
      'availableTimeJson',
      this,
    );
    locationRef = _i1.ColumnString(
      'locationRef',
      this,
    );
    active = _i1.ColumnBool(
      'active',
      this,
    );
    comment = _i1.ColumnString(
      'comment',
      this,
    );
    telecom = _i1.ColumnString(
      'telecom',
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

  late final HealthcareServiceUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString organizationRef;

  late final _i1.ColumnString name;

  late final _i1.ColumnString type;

  late final _i1.ColumnString specialty;

  late final _i1.ColumnString availableTimeJson;

  late final _i1.ColumnString locationRef;

  late final _i1.ColumnBool active;

  late final _i1.ColumnString comment;

  late final _i1.ColumnString telecom;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    organizationRef,
    name,
    type,
    specialty,
    availableTimeJson,
    locationRef,
    active,
    comment,
    telecom,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class HealthcareServiceInclude extends _i1.IncludeObject {
  HealthcareServiceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HealthcareService.t;
}

class HealthcareServiceIncludeList extends _i1.IncludeList {
  HealthcareServiceIncludeList._({
    _i1.WhereExpressionBuilder<HealthcareServiceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HealthcareService.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HealthcareService.t;
}

class HealthcareServiceRepository {
  const HealthcareServiceRepository._();

  /// Returns a list of [HealthcareService]s matching the given query parameters.
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
  Future<List<HealthcareService>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HealthcareServiceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HealthcareServiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HealthcareServiceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HealthcareService>(
      where: where?.call(HealthcareService.t),
      orderBy: orderBy?.call(HealthcareService.t),
      orderByList: orderByList?.call(HealthcareService.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HealthcareService] matching the given query parameters.
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
  Future<HealthcareService?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HealthcareServiceTable>? where,
    int? offset,
    _i1.OrderByBuilder<HealthcareServiceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HealthcareServiceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HealthcareService>(
      where: where?.call(HealthcareService.t),
      orderBy: orderBy?.call(HealthcareService.t),
      orderByList: orderByList?.call(HealthcareService.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HealthcareService] by its [id] or null if no such row exists.
  Future<HealthcareService?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HealthcareService>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HealthcareService]s in the list and returns the inserted rows.
  ///
  /// The returned [HealthcareService]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HealthcareService>> insert(
    _i1.DatabaseSession session,
    List<HealthcareService> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HealthcareService>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HealthcareService] and returns the inserted row.
  ///
  /// The returned [HealthcareService] will have its `id` field set.
  Future<HealthcareService> insertRow(
    _i1.DatabaseSession session,
    HealthcareService row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HealthcareService>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HealthcareService]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HealthcareService>> update(
    _i1.DatabaseSession session,
    List<HealthcareService> rows, {
    _i1.ColumnSelections<HealthcareServiceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HealthcareService>(
      rows,
      columns: columns?.call(HealthcareService.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthcareService]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HealthcareService> updateRow(
    _i1.DatabaseSession session,
    HealthcareService row, {
    _i1.ColumnSelections<HealthcareServiceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HealthcareService>(
      row,
      columns: columns?.call(HealthcareService.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthcareService] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HealthcareService?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HealthcareServiceUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HealthcareService>(
      id,
      columnValues: columnValues(HealthcareService.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HealthcareService]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HealthcareService>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HealthcareServiceUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<HealthcareServiceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HealthcareServiceTable>? orderBy,
    _i1.OrderByListBuilder<HealthcareServiceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HealthcareService>(
      columnValues: columnValues(HealthcareService.t.updateTable),
      where: where(HealthcareService.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthcareService.t),
      orderByList: orderByList?.call(HealthcareService.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HealthcareService]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HealthcareService>> delete(
    _i1.DatabaseSession session,
    List<HealthcareService> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HealthcareService>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HealthcareService].
  Future<HealthcareService> deleteRow(
    _i1.DatabaseSession session,
    HealthcareService row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HealthcareService>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HealthcareService>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HealthcareServiceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HealthcareService>(
      where: where(HealthcareService.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HealthcareServiceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HealthcareService>(
      where: where?.call(HealthcareService.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HealthcareService] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HealthcareServiceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HealthcareService>(
      where: where(HealthcareService.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
