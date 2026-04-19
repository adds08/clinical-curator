import 'package:clinical_curator_client/clinical_curator_client.dart';

import '../rbac_repository.dart';

class ServerRbacRepository implements RbacRepository {
  ServerRbacRepository(this._client);
  final Client _client;

  @override
  Future<List<RbacPermission>> listAll() => _client.rbac.listAll();

  @override
  Future<List<RbacPermission>> listForRole(String roleId) =>
      _client.rbac.listForRole(roleId);

  @override
  Future<RbacPermission> setPermission({
    required String roleId,
    required String roleName,
    required String resource,
    required String action,
    required bool isAllowed,
  }) =>
      _client.rbac.setPermission(
        roleId,
        roleName,
        resource,
        action,
        isAllowed,
      );

  @override
  Future<bool> deletePermission(int id) => _client.rbac.deletePermission(id);
}
