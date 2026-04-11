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

/// Ambulance dispatch request with tracking status.
abstract class AmbulanceRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AmbulanceRequest._({
    this.id,
    required this.patientRef,
    required this.patientName,
    required this.contactNumber,
    required this.emergencyType,
    required this.pickupLocation,
    required this.status,
    this.latitude,
    this.longitude,
    this.assignedDriverName,
    this.assignedVehicleNumber,
    this.estimatedArrivalMinutes,
    this.notes,
    this.cancellationReason,
    this.timelinessRating,
    this.helpfulnessRating,
    this.feedbackNotes,
    required this.createdAt,
    this.updatedAt,
  });

  factory AmbulanceRequest({
    int? id,
    required String patientRef,
    required String patientName,
    required String contactNumber,
    required String emergencyType,
    required String pickupLocation,
    required String status,
    double? latitude,
    double? longitude,
    String? assignedDriverName,
    String? assignedVehicleNumber,
    int? estimatedArrivalMinutes,
    String? notes,
    String? cancellationReason,
    String? timelinessRating,
    int? helpfulnessRating,
    String? feedbackNotes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AmbulanceRequestImpl;

  factory AmbulanceRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return AmbulanceRequest(
      id: jsonSerialization['id'] as int?,
      patientRef: jsonSerialization['patientRef'] as String,
      patientName: jsonSerialization['patientName'] as String,
      contactNumber: jsonSerialization['contactNumber'] as String,
      emergencyType: jsonSerialization['emergencyType'] as String,
      pickupLocation: jsonSerialization['pickupLocation'] as String,
      status: jsonSerialization['status'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      assignedDriverName: jsonSerialization['assignedDriverName'] as String?,
      assignedVehicleNumber:
          jsonSerialization['assignedVehicleNumber'] as String?,
      estimatedArrivalMinutes:
          jsonSerialization['estimatedArrivalMinutes'] as int?,
      notes: jsonSerialization['notes'] as String?,
      cancellationReason: jsonSerialization['cancellationReason'] as String?,
      timelinessRating: jsonSerialization['timelinessRating'] as String?,
      helpfulnessRating: jsonSerialization['helpfulnessRating'] as int?,
      feedbackNotes: jsonSerialization['feedbackNotes'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = AmbulanceRequestTable();

  static const db = AmbulanceRequestRepository._();

  @override
  int? id;

  String patientRef;

  String patientName;

  String contactNumber;

  String emergencyType;

  String pickupLocation;

  String status;

  double? latitude;

  double? longitude;

  String? assignedDriverName;

  String? assignedVehicleNumber;

  int? estimatedArrivalMinutes;

  String? notes;

  String? cancellationReason;

  String? timelinessRating;

  int? helpfulnessRating;

  String? feedbackNotes;

  DateTime createdAt;

  DateTime? updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AmbulanceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AmbulanceRequest copyWith({
    int? id,
    String? patientRef,
    String? patientName,
    String? contactNumber,
    String? emergencyType,
    String? pickupLocation,
    String? status,
    double? latitude,
    double? longitude,
    String? assignedDriverName,
    String? assignedVehicleNumber,
    int? estimatedArrivalMinutes,
    String? notes,
    String? cancellationReason,
    String? timelinessRating,
    int? helpfulnessRating,
    String? feedbackNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AmbulanceRequest',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'patientName': patientName,
      'contactNumber': contactNumber,
      'emergencyType': emergencyType,
      'pickupLocation': pickupLocation,
      'status': status,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (assignedDriverName != null) 'assignedDriverName': assignedDriverName,
      if (assignedVehicleNumber != null)
        'assignedVehicleNumber': assignedVehicleNumber,
      if (estimatedArrivalMinutes != null)
        'estimatedArrivalMinutes': estimatedArrivalMinutes,
      if (notes != null) 'notes': notes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (timelinessRating != null) 'timelinessRating': timelinessRating,
      if (helpfulnessRating != null) 'helpfulnessRating': helpfulnessRating,
      if (feedbackNotes != null) 'feedbackNotes': feedbackNotes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AmbulanceRequest',
      if (id != null) 'id': id,
      'patientRef': patientRef,
      'patientName': patientName,
      'contactNumber': contactNumber,
      'emergencyType': emergencyType,
      'pickupLocation': pickupLocation,
      'status': status,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (assignedDriverName != null) 'assignedDriverName': assignedDriverName,
      if (assignedVehicleNumber != null)
        'assignedVehicleNumber': assignedVehicleNumber,
      if (estimatedArrivalMinutes != null)
        'estimatedArrivalMinutes': estimatedArrivalMinutes,
      if (notes != null) 'notes': notes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (timelinessRating != null) 'timelinessRating': timelinessRating,
      if (helpfulnessRating != null) 'helpfulnessRating': helpfulnessRating,
      if (feedbackNotes != null) 'feedbackNotes': feedbackNotes,
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  static AmbulanceRequestInclude include() {
    return AmbulanceRequestInclude._();
  }

  static AmbulanceRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<AmbulanceRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AmbulanceRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AmbulanceRequestTable>? orderByList,
    AmbulanceRequestInclude? include,
  }) {
    return AmbulanceRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AmbulanceRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AmbulanceRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AmbulanceRequestImpl extends AmbulanceRequest {
  _AmbulanceRequestImpl({
    int? id,
    required String patientRef,
    required String patientName,
    required String contactNumber,
    required String emergencyType,
    required String pickupLocation,
    required String status,
    double? latitude,
    double? longitude,
    String? assignedDriverName,
    String? assignedVehicleNumber,
    int? estimatedArrivalMinutes,
    String? notes,
    String? cancellationReason,
    String? timelinessRating,
    int? helpfulnessRating,
    String? feedbackNotes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         patientRef: patientRef,
         patientName: patientName,
         contactNumber: contactNumber,
         emergencyType: emergencyType,
         pickupLocation: pickupLocation,
         status: status,
         latitude: latitude,
         longitude: longitude,
         assignedDriverName: assignedDriverName,
         assignedVehicleNumber: assignedVehicleNumber,
         estimatedArrivalMinutes: estimatedArrivalMinutes,
         notes: notes,
         cancellationReason: cancellationReason,
         timelinessRating: timelinessRating,
         helpfulnessRating: helpfulnessRating,
         feedbackNotes: feedbackNotes,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AmbulanceRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AmbulanceRequest copyWith({
    Object? id = _Undefined,
    String? patientRef,
    String? patientName,
    String? contactNumber,
    String? emergencyType,
    String? pickupLocation,
    String? status,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? assignedDriverName = _Undefined,
    Object? assignedVehicleNumber = _Undefined,
    Object? estimatedArrivalMinutes = _Undefined,
    Object? notes = _Undefined,
    Object? cancellationReason = _Undefined,
    Object? timelinessRating = _Undefined,
    Object? helpfulnessRating = _Undefined,
    Object? feedbackNotes = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return AmbulanceRequest(
      id: id is int? ? id : this.id,
      patientRef: patientRef ?? this.patientRef,
      patientName: patientName ?? this.patientName,
      contactNumber: contactNumber ?? this.contactNumber,
      emergencyType: emergencyType ?? this.emergencyType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      status: status ?? this.status,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      assignedDriverName: assignedDriverName is String?
          ? assignedDriverName
          : this.assignedDriverName,
      assignedVehicleNumber: assignedVehicleNumber is String?
          ? assignedVehicleNumber
          : this.assignedVehicleNumber,
      estimatedArrivalMinutes: estimatedArrivalMinutes is int?
          ? estimatedArrivalMinutes
          : this.estimatedArrivalMinutes,
      notes: notes is String? ? notes : this.notes,
      cancellationReason: cancellationReason is String?
          ? cancellationReason
          : this.cancellationReason,
      timelinessRating: timelinessRating is String?
          ? timelinessRating
          : this.timelinessRating,
      helpfulnessRating: helpfulnessRating is int?
          ? helpfulnessRating
          : this.helpfulnessRating,
      feedbackNotes: feedbackNotes is String?
          ? feedbackNotes
          : this.feedbackNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}

class AmbulanceRequestUpdateTable
    extends _i1.UpdateTable<AmbulanceRequestTable> {
  AmbulanceRequestUpdateTable(super.table);

  _i1.ColumnValue<String, String> patientRef(String value) => _i1.ColumnValue(
    table.patientRef,
    value,
  );

  _i1.ColumnValue<String, String> patientName(String value) => _i1.ColumnValue(
    table.patientName,
    value,
  );

  _i1.ColumnValue<String, String> contactNumber(String value) =>
      _i1.ColumnValue(
        table.contactNumber,
        value,
      );

  _i1.ColumnValue<String, String> emergencyType(String value) =>
      _i1.ColumnValue(
        table.emergencyType,
        value,
      );

  _i1.ColumnValue<String, String> pickupLocation(String value) =>
      _i1.ColumnValue(
        table.pickupLocation,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
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

  _i1.ColumnValue<String, String> assignedDriverName(String? value) =>
      _i1.ColumnValue(
        table.assignedDriverName,
        value,
      );

  _i1.ColumnValue<String, String> assignedVehicleNumber(String? value) =>
      _i1.ColumnValue(
        table.assignedVehicleNumber,
        value,
      );

  _i1.ColumnValue<int, int> estimatedArrivalMinutes(int? value) =>
      _i1.ColumnValue(
        table.estimatedArrivalMinutes,
        value,
      );

  _i1.ColumnValue<String, String> notes(String? value) => _i1.ColumnValue(
    table.notes,
    value,
  );

  _i1.ColumnValue<String, String> cancellationReason(String? value) =>
      _i1.ColumnValue(
        table.cancellationReason,
        value,
      );

  _i1.ColumnValue<String, String> timelinessRating(String? value) =>
      _i1.ColumnValue(
        table.timelinessRating,
        value,
      );

  _i1.ColumnValue<int, int> helpfulnessRating(int? value) => _i1.ColumnValue(
    table.helpfulnessRating,
    value,
  );

  _i1.ColumnValue<String, String> feedbackNotes(String? value) =>
      _i1.ColumnValue(
        table.feedbackNotes,
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

class AmbulanceRequestTable extends _i1.Table<int?> {
  AmbulanceRequestTable({super.tableRelation})
    : super(tableName: 'ambulance_requests') {
    updateTable = AmbulanceRequestUpdateTable(this);
    patientRef = _i1.ColumnString(
      'patientRef',
      this,
    );
    patientName = _i1.ColumnString(
      'patientName',
      this,
    );
    contactNumber = _i1.ColumnString(
      'contactNumber',
      this,
    );
    emergencyType = _i1.ColumnString(
      'emergencyType',
      this,
    );
    pickupLocation = _i1.ColumnString(
      'pickupLocation',
      this,
    );
    status = _i1.ColumnString(
      'status',
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
    assignedDriverName = _i1.ColumnString(
      'assignedDriverName',
      this,
    );
    assignedVehicleNumber = _i1.ColumnString(
      'assignedVehicleNumber',
      this,
    );
    estimatedArrivalMinutes = _i1.ColumnInt(
      'estimatedArrivalMinutes',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    cancellationReason = _i1.ColumnString(
      'cancellationReason',
      this,
    );
    timelinessRating = _i1.ColumnString(
      'timelinessRating',
      this,
    );
    helpfulnessRating = _i1.ColumnInt(
      'helpfulnessRating',
      this,
    );
    feedbackNotes = _i1.ColumnString(
      'feedbackNotes',
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

  late final AmbulanceRequestUpdateTable updateTable;

  late final _i1.ColumnString patientRef;

  late final _i1.ColumnString patientName;

  late final _i1.ColumnString contactNumber;

  late final _i1.ColumnString emergencyType;

  late final _i1.ColumnString pickupLocation;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString assignedDriverName;

  late final _i1.ColumnString assignedVehicleNumber;

  late final _i1.ColumnInt estimatedArrivalMinutes;

  late final _i1.ColumnString notes;

  late final _i1.ColumnString cancellationReason;

  late final _i1.ColumnString timelinessRating;

  late final _i1.ColumnInt helpfulnessRating;

  late final _i1.ColumnString feedbackNotes;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    patientRef,
    patientName,
    contactNumber,
    emergencyType,
    pickupLocation,
    status,
    latitude,
    longitude,
    assignedDriverName,
    assignedVehicleNumber,
    estimatedArrivalMinutes,
    notes,
    cancellationReason,
    timelinessRating,
    helpfulnessRating,
    feedbackNotes,
    createdAt,
    updatedAt,
  ];
}

class AmbulanceRequestInclude extends _i1.IncludeObject {
  AmbulanceRequestInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AmbulanceRequest.t;
}

class AmbulanceRequestIncludeList extends _i1.IncludeList {
  AmbulanceRequestIncludeList._({
    _i1.WhereExpressionBuilder<AmbulanceRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AmbulanceRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AmbulanceRequest.t;
}

class AmbulanceRequestRepository {
  const AmbulanceRequestRepository._();

  /// Returns a list of [AmbulanceRequest]s matching the given query parameters.
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
  Future<List<AmbulanceRequest>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AmbulanceRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AmbulanceRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AmbulanceRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AmbulanceRequest>(
      where: where?.call(AmbulanceRequest.t),
      orderBy: orderBy?.call(AmbulanceRequest.t),
      orderByList: orderByList?.call(AmbulanceRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AmbulanceRequest] matching the given query parameters.
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
  Future<AmbulanceRequest?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AmbulanceRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<AmbulanceRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AmbulanceRequestTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AmbulanceRequest>(
      where: where?.call(AmbulanceRequest.t),
      orderBy: orderBy?.call(AmbulanceRequest.t),
      orderByList: orderByList?.call(AmbulanceRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AmbulanceRequest] by its [id] or null if no such row exists.
  Future<AmbulanceRequest?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AmbulanceRequest>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AmbulanceRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [AmbulanceRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AmbulanceRequest>> insert(
    _i1.DatabaseSession session,
    List<AmbulanceRequest> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AmbulanceRequest>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AmbulanceRequest] and returns the inserted row.
  ///
  /// The returned [AmbulanceRequest] will have its `id` field set.
  Future<AmbulanceRequest> insertRow(
    _i1.DatabaseSession session,
    AmbulanceRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AmbulanceRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AmbulanceRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AmbulanceRequest>> update(
    _i1.DatabaseSession session,
    List<AmbulanceRequest> rows, {
    _i1.ColumnSelections<AmbulanceRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AmbulanceRequest>(
      rows,
      columns: columns?.call(AmbulanceRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AmbulanceRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AmbulanceRequest> updateRow(
    _i1.DatabaseSession session,
    AmbulanceRequest row, {
    _i1.ColumnSelections<AmbulanceRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AmbulanceRequest>(
      row,
      columns: columns?.call(AmbulanceRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AmbulanceRequest] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AmbulanceRequest?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AmbulanceRequestUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AmbulanceRequest>(
      id,
      columnValues: columnValues(AmbulanceRequest.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AmbulanceRequest]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AmbulanceRequest>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AmbulanceRequestUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AmbulanceRequestTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AmbulanceRequestTable>? orderBy,
    _i1.OrderByListBuilder<AmbulanceRequestTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AmbulanceRequest>(
      columnValues: columnValues(AmbulanceRequest.t.updateTable),
      where: where(AmbulanceRequest.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AmbulanceRequest.t),
      orderByList: orderByList?.call(AmbulanceRequest.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AmbulanceRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AmbulanceRequest>> delete(
    _i1.DatabaseSession session,
    List<AmbulanceRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AmbulanceRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AmbulanceRequest].
  Future<AmbulanceRequest> deleteRow(
    _i1.DatabaseSession session,
    AmbulanceRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AmbulanceRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AmbulanceRequest>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AmbulanceRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AmbulanceRequest>(
      where: where(AmbulanceRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AmbulanceRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AmbulanceRequest>(
      where: where?.call(AmbulanceRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AmbulanceRequest] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AmbulanceRequestTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AmbulanceRequest>(
      where: where(AmbulanceRequest.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
