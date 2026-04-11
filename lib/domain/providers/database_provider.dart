import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

import '../../core/database/isar_service.dart';
import '../../data/collections/user_account_collection.dart';
import '../../data/collections/fhir_resource_collection.dart';

final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final userAccountsBoxProvider = Provider<Box<UserAccount>>((ref) {
  return DatabaseService.userAccounts;
});

final fhirResourcesBoxProvider = Provider<Box<FhirResource>>((ref) {
  return DatabaseService.fhirResources;
});
