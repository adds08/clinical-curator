import 'package:serverpod/serverpod.dart';

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Clinical Curator API — $name';
  }
}
