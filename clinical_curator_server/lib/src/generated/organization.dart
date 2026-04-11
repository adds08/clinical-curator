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

/// Hospital, pharmacy, or facility (maps to FHIR Organization/Location).
abstract class Organization
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Organization._({
    this.id,
    this.fhirId,
    required this.name,
    required this.type,
    required this.address,
    this.phone,
    this.latitude,
    this.longitude,
    this.openHours,
    this.rating,
    required this.hasEmergency,
    required this.isOpen24Hours,
    this.departmentsJson,
    this.servicesJson,
    required this.createdAt,
  });

  factory Organization({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    required String address,
    String? phone,
    double? latitude,
    double? longitude,
    String? openHours,
    double? rating,
    required bool hasEmergency,
    required bool isOpen24Hours,
    String? departmentsJson,
    String? servicesJson,
    required DateTime createdAt,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      fhirId: jsonSerialization['fhirId'] as String?,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      address: jsonSerialization['address'] as String,
      phone: jsonSerialization['phone'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      openHours: jsonSerialization['openHours'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      hasEmergency: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hasEmergency'],
      ),
      isOpen24Hours: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isOpen24Hours'],
      ),
      departmentsJson: jsonSerialization['departmentsJson'] as String?,
      servicesJson: jsonSerialization['servicesJson'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = OrganizationTable();

  static const db = OrganizationRepository._();

  @override
  int? id;

  String? fhirId;

  String name;

  String type;

  String address;

  String? phone;

  double? latitude;

  double? longitude;

  String? openHours;

  double? rating;

  bool hasEmergency;

  bool isOpen24Hours;

  String? departmentsJson;

  String? servicesJson;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Organization copyWith({
    int? id,
    String? fhirId,
    String? name,
    String? type,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? openHours,
    double? rating,
    bool? hasEmergency,
    bool? isOpen24Hours,
    String? departmentsJson,
    String? servicesJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Organization',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'name': name,
      'type': type,
      'address': address,
      if (phone != null) 'phone': phone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (openHours != null) 'openHours': openHours,
      if (rating != null) 'rating': rating,
      'hasEmergency': hasEmergency,
      'isOpen24Hours': isOpen24Hours,
      if (departmentsJson != null) 'departmentsJson': departmentsJson,
      if (servicesJson != null) 'servicesJson': servicesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Organization',
      if (id != null) 'id': id,
      if (fhirId != null) 'fhirId': fhirId,
      'name': name,
      'type': type,
      'address': address,
      if (phone != null) 'phone': phone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (openHours != null) 'openHours': openHours,
      if (rating != null) 'rating': rating,
      'hasEmergency': hasEmergency,
      'isOpen24Hours': isOpen24Hours,
      if (departmentsJson != null) 'departmentsJson': departmentsJson,
      if (servicesJson != null) 'servicesJson': servicesJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static OrganizationInclude include() {
    return OrganizationInclude._();
  }

  static OrganizationIncludeList includeList({
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    OrganizationInclude? include,
  }) {
    return OrganizationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Organization.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    String? fhirId,
    required String name,
    required String type,
    required String address,
    String? phone,
    double? latitude,
    double? longitude,
    String? openHours,
    double? rating,
    required bool hasEmergency,
    required bool isOpen24Hours,
    String? departmentsJson,
    String? servicesJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         fhirId: fhirId,
         name: name,
         type: type,
         address: address,
         phone: phone,
         latitude: latitude,
         longitude: longitude,
         openHours: openHours,
         rating: rating,
         hasEmergency: hasEmergency,
         isOpen24Hours: isOpen24Hours,
         departmentsJson: departmentsJson,
         servicesJson: servicesJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Organization copyWith({
    Object? id = _Undefined,
    Object? fhirId = _Undefined,
    String? name,
    String? type,
    String? address,
    Object? phone = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? openHours = _Undefined,
    Object? rating = _Undefined,
    bool? hasEmergency,
    bool? isOpen24Hours,
    Object? departmentsJson = _Undefined,
    Object? servicesJson = _Undefined,
    DateTime? createdAt,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      fhirId: fhirId is String? ? fhirId : this.fhirId,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      phone: phone is String? ? phone : this.phone,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      openHours: openHours is String? ? openHours : this.openHours,
      rating: rating is double? ? rating : this.rating,
      hasEmergency: hasEmergency ?? this.hasEmergency,
      isOpen24Hours: isOpen24Hours ?? this.isOpen24Hours,
      departmentsJson: departmentsJson is String?
          ? departmentsJson
          : this.departmentsJson,
      servicesJson: servicesJson is String? ? servicesJson : this.servicesJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OrganizationUpdateTable extends _i1.UpdateTable<OrganizationTable> {
  OrganizationUpdateTable(super.table);

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

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<String, String> phone(String? value) => _i1.ColumnValue(
    table.phone,
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

  _i1.ColumnValue<String, String> openHours(String? value) => _i1.ColumnValue(
    table.openHours,
    value,
  );

  _i1.ColumnValue<double, double> rating(double? value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<bool, bool> hasEmergency(bool value) => _i1.ColumnValue(
    table.hasEmergency,
    value,
  );

  _i1.ColumnValue<bool, bool> isOpen24Hours(bool value) => _i1.ColumnValue(
    table.isOpen24Hours,
    value,
  );

  _i1.ColumnValue<String, String> departmentsJson(String? value) =>
      _i1.ColumnValue(
        table.departmentsJson,
        value,
      );

  _i1.ColumnValue<String, String> servicesJson(String? value) =>
      _i1.ColumnValue(
        table.servicesJson,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class OrganizationTable extends _i1.Table<int?> {
  OrganizationTable({super.tableRelation}) : super(tableName: 'organizations') {
    updateTable = OrganizationUpdateTable(this);
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
    address = _i1.ColumnString(
      'address',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
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
    openHours = _i1.ColumnString(
      'openHours',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
    );
    hasEmergency = _i1.ColumnBool(
      'hasEmergency',
      this,
    );
    isOpen24Hours = _i1.ColumnBool(
      'isOpen24Hours',
      this,
    );
    departmentsJson = _i1.ColumnString(
      'departmentsJson',
      this,
    );
    servicesJson = _i1.ColumnString(
      'servicesJson',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final OrganizationUpdateTable updateTable;

  late final _i1.ColumnString fhirId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString type;

  late final _i1.ColumnString address;

  late final _i1.ColumnString phone;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString openHours;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnBool hasEmergency;

  late final _i1.ColumnBool isOpen24Hours;

  late final _i1.ColumnString departmentsJson;

  late final _i1.ColumnString servicesJson;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    fhirId,
    name,
    type,
    address,
    phone,
    latitude,
    longitude,
    openHours,
    rating,
    hasEmergency,
    isOpen24Hours,
    departmentsJson,
    servicesJson,
    createdAt,
  ];
}

class OrganizationInclude extends _i1.IncludeObject {
  OrganizationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Organization.t;
}

class OrganizationIncludeList extends _i1.IncludeList {
  OrganizationIncludeList._({
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Organization.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Organization.t;
}

class OrganizationRepository {
  const OrganizationRepository._();

  /// Returns a list of [Organization]s matching the given query parameters.
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
  Future<List<Organization>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Organization] matching the given query parameters.
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
  Future<Organization?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Organization] by its [id] or null if no such row exists.
  Future<Organization?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Organization>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Organization]s in the list and returns the inserted rows.
  ///
  /// The returned [Organization]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Organization>> insert(
    _i1.DatabaseSession session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Organization>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Organization] and returns the inserted row.
  ///
  /// The returned [Organization] will have its `id` field set.
  Future<Organization> insertRow(
    _i1.DatabaseSession session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Organization]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Organization>> update(
    _i1.DatabaseSession session,
    List<Organization> rows, {
    _i1.ColumnSelections<OrganizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Organization>(
      rows,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Organization]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Organization> updateRow(
    _i1.DatabaseSession session,
    Organization row, {
    _i1.ColumnSelections<OrganizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Organization>(
      row,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Organization] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Organization?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OrganizationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Organization>(
      id,
      columnValues: columnValues(Organization.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Organization]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Organization>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrganizationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Organization>(
      columnValues: columnValues(Organization.t.updateTable),
      where: where(Organization.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Organization]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Organization>> delete(
    _i1.DatabaseSession session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Organization>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Organization].
  Future<Organization> deleteRow(
    _i1.DatabaseSession session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Organization>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Organization>(
      where: where(Organization.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Organization>(
      where: where?.call(Organization.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Organization] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Organization>(
      where: where(Organization.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
