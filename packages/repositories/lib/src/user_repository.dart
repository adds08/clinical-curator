import 'package:clinical_curator_client/clinical_curator_client.dart';

abstract class UserRepository {
  Future<List<UserAccount>> listAll({String? accountType});
  Future<List<UserAccount>> listPendingPractitioners();
  Future<List<UserAccount>> listVerifiedPractitioners();
  Future<UserAccount?> getById(int id);
  Future<UserAccount?> getByEmail(String email);
  Future<UserAccount> approvePractitioner(int id);
  Future<UserAccount> rejectPractitioner(int id);
  Future<UserAccount> setVerified(int id, bool isVerified);
}
