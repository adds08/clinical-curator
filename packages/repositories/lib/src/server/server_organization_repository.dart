import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../organization_repository.dart';

class ServerOrganizationRepository implements OrganizationRepository {
  ServerOrganizationRepository(this._client);
  final Client _client;

  @override
  Future<List<Organization>> listAll() => _client.organization.listAll();

  @override
  Future<List<Organization>> listHospitals() =>
      _client.organization.listHospitals();

  @override
  Future<List<Organization>> listPharmacies() =>
      _client.organization.listPharmacies();

  @override
  Future<List<Organization>> search(String query) =>
      _client.organization.search(query);

  @override
  Future<Organization?> getById(int id) => _client.organization.getById(id);

  @override
  Future<Organization> create(Organization org) =>
      _client.organization.create(org);

  @override
  Future<Organization> update(Organization org) =>
      _client.organization.update(org);

  @override
  Future<bool> delete(int id) => _client.organization.delete(id);
}
