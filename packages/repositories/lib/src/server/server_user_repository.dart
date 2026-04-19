import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../user_repository.dart';

class ServerUserRepository implements UserRepository {
  ServerUserRepository(this._client);
  final Client _client;

  @override
  Future<List<UserAccount>> listAll({String? accountType}) =>
      _client.admin.listAllUsers(accountType: accountType);

  @override
  Future<List<UserAccount>> listPendingPractitioners() =>
      _client.admin.listPendingVerifications();

  @override
  Future<List<UserAccount>> listVerifiedPractitioners() =>
      _client.admin.listVerifiedPractitioners();

  @override
  Future<UserAccount?> getById(int id) => _client.auth.getById(id);

  @override
  Future<UserAccount?> getByEmail(String email) =>
      _client.auth.getByEmail(email);

  @override
  Future<UserAccount> approvePractitioner(int id) =>
      _client.admin.approvePractitioner(id);

  @override
  Future<UserAccount> rejectPractitioner(int id) =>
      _client.admin.rejectPractitioner(id);

  @override
  Future<UserAccount> setVerified(int id, bool isVerified) =>
      _client.admin.setUserVerified(id, isVerified);
}
