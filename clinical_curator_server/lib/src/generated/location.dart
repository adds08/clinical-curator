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

/// Physical location within a facility.
abstract class Location
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Location._({
    this.id,
    this.fhirId,
    required this.name,
    required this.type,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.organizationRef,
    this.partOfRef,
    required this.status,
    this.physicalType,
    required this.createdAt,
    this.updatedAt,
    required this.syncVersion,
  });

  factory Location({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? organizationRef,
    String? partOfRef,
    required String status,
    String? physicalType,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) = _LocationImpl;

  factory Location.fromJson(Map<String, dynamic> jsonSerialization) {
    return Location(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      description: jsonSerialization['description'] as String?,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      organizationRef: jsonSerialization['organizationRef'] as String?,
      partOfRef: jsonSerialization['partOfRef'] as String?,
      status: jsonSerialization['status'] as String,
      physicalType: jsonSerialization['physicalType'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      syncVersion: jsonSerialization['syncVersion'] as int,
    );
  }

  static final t = LocationTable();

  static const db = LocationRepository._();

  @override
  int? id;

  String? fhirId;

  String name;

  String type;

  String? description;

  String? address;

  double? latitude;

  double? longitude;

  String? organizationRef;

  String? partOfRef;

  String status;

  String? physicalType;

  DateTime createdAt;

  DateTime? updatedAt;

  int syncVersion;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Location copyWith({
    int? id,
    String? fhirId,
    String? name,
    String? type,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? organizationRef,
    String? partOfRef,
    String? status,
    String? physicalType,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (partOfRef != null) 'partOfRef': partOfRef,
      'status': status,
      if (physicalType != null) 'physicalType': physicalType,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Location',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'name': name,
      'type': type,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (organizationRef != null) 'organizationRef': organizationRef,
      if (partOfRef != null) 'partOfRef': partOfRef,
      'status': status,
      if (physicalType != null) 'physicalType': physicalType,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
      'syncVersion': syncVersion,
    };
  }

  static LocationInclude include() {
    return LocationInclude._();
  }

  static LocationIncludeList includeList({
    _i1.WhereExpressionBuilder<LocationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LocationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LocationTable>? orderByList,
    LocationInclude? include,
  }) {
    return LocationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Location.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Location.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocationImpl extends Location {
  _LocationImpl({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? organizationRef,
    String? partOfRef,
    required String status,
    String? physicalType,
    required DateTime createdAt,
    DateTime? updatedAt,
    required int syncVersion,
  }) : super._(
         id: id,
         fhirId: fhirId,
         name: name,
         type: type,
         description: description,
         address: address,
         latitude: latitude,
         longitude: longitude,
         organizationRef: organizationRef,
         partOfRef: partOfRef,
         status: status,
         physicalType: physicalType,
         createdAt: createdAt,
         updatedAt: updatedAt,
         syncVersion: syncVersion,
       );

  /// Returns a shallow copy of this [Location]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Location copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? name,
    String? type,
    Object? description = _Undefined,
    Object? address = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? organizationRef = _Undefined,
    Object? partOfRef = _Undefined,
    String? status,
    Object? physicalType = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
    int? syncVersion,
  }) {
    return Location(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description is String? ? description : this.description,
      address: address is String? ? address : this.address,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      organizationRef: organizationRef is String?
          ? organizationRef
          : this.organizationRef,
      partOfRef: partOfRef is String? ? partOfRef : this.partOfRef,
      status: status ?? this.status,
      physicalType: physicalType is String? ? physicalType : this.physicalType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
      syncVersion: syncVersion ?? this.syncVersion,
    );
  }
}

class LocationUpdateTable extends _i1.UpdateTable<LocationTable> {
  LocationUpdateTable(super.table);

  _i1.ColumnValue<String, String> fhirId(String? value) => _i1.ColumnValue(
    table.fhirId,
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

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> address(String? value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<String, String> organizationRef(String? value) =>
      _i1.ColumnValue(
        table.organizationRef,
        value,
      );

  _i1.ColumnValue<String, String> partOfRef(String? value) => _i1.ColumnValue(
    table.partOfRef,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> physicalType(String? value) =>
      _i1.ColumnValue(
        table.physicalType,
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

class LocationTable extends _i1.Table<int?> {
  LocationTable({super.tableRelation}) : super(tableName: 'locations') {
    updateTable = LocationUpdateTable(this);
    fhirId = _i1.ColumnString(
      'fhirId',
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
    description = _i1.ColumnString(
      'description',
      this,
    );
    address = _i1.ColumnString(
      'address',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    organizationRef = _i1.ColumnString(
      'organizationRef',
      this,
    );
    partOfRef = _i1.ColumnString(
      'partOfRef',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    physicalType = _i1.ColumnString(
      'physicalType',
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

  late final LocationUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString type;

  late final _i1.ColumnString description;

  late final _i1.ColumnString address;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString organizationRef;

  late final _i1.ColumnString partOfRef;

  late final _i1.ColumnString status;

  late final _i1.ColumnString physicalType;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt syncVersion;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    name,
    type,
    description,
    address,
    latitude,
    longitude,
    organizationRef,
    partOfRef,
    status,
    physicalType,
    createdAt,
    updatedAt,
    syncVersion,
  ];
}

class LocationInclude extends _i1.IncludeObject {
  LocationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Location.t;
}

class LocationIncludeList extends _i1.IncludeList {
  LocationIncludeList._({
    _i1.WhereExpressionBuilder<LocationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Location.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Location.t;
}

class LocationRepository {
  const LocationRepository._();

  /// Returns a list of [Location]s matching the given query parameters.
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
  Future<List<Location>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LocationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LocationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LocationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Location>(
      where: where?.call(Location.t),
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Location] matching the given query parameters.
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
  Future<Location?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LocationTable>? where,
    int? offset,
    _i1.OrderByBuilder<LocationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LocationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Location>(
      where: where?.call(Location.t),
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Location] by its [id] or null if no such row exists.
  Future<Location?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Location>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Location]s in the list and returns the inserted rows.
  ///
  /// The returned [Location]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Location>> insert(
    _i1.DatabaseSession session,
    List<Location> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Location>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Location] and returns the inserted row.
  ///
  /// The returned [Location] will have its `id` field set.
  Future<Location> insertRow(
    _i1.DatabaseSession session,
    Location row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Location>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Location]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Location>> update(
    _i1.DatabaseSession session,
    List<Location> rows, {
    _i1.ColumnSelections<LocationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Location>(
      rows,
      columns: columns?.call(Location.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Location]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Location> updateRow(
    _i1.DatabaseSession session,
    Location row, {
    _i1.ColumnSelections<LocationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Location>(
      row,
      columns: columns?.call(Location.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Location] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Location?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<LocationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Location>(
      id,
      columnValues: columnValues(Location.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Location]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Location>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<LocationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<LocationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LocationTable>? orderBy,
    _i1.OrderByListBuilder<LocationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Location>(
      columnValues: columnValues(Location.t.updateTable),
      where: where(Location.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Location.t),
      orderByList: orderByList?.call(Location.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Location]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Location>> delete(
    _i1.DatabaseSession session,
    List<Location> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Location>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Location].
  Future<Location> deleteRow(
    _i1.DatabaseSession session,
    Location row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Location>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Location>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LocationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Location>(
      where: where(Location.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<LocationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Location>(
      where: where?.call(Location.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Location] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<LocationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Location>(
      where: where(Location.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
