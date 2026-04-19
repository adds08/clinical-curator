import 'package:clinical_curator_client/clinical_curator_client.dart';

abstract class OrganizationRepository {
  Future<List<Organization>> listAll();
  Future<List<Organization>> listHospitals();
  Future<List<Organization>> listPharmacies();
  Future<List<Organization>> search(String query);
  Future<Organization?> getById(int id);
  Future<Organization> create(Organization org);
  Future<Organization> update(Organization org);
  Future<bool> delete(int id);
}
