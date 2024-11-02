import 'ezy_client.dart';
import 'ezy_config.dart';

class EzyClients {
  String defaultClientName = "";
  Map<String, EzyClient> clients = <String, EzyClient>{};
  static final EzyClients _INSTANCE = EzyClients._();

  EzyClients._();

  static EzyClients getInstance() {
    return _INSTANCE;
  }

  EzyClient newClient(EzyConfig config) {
    var client = EzyClient(config);
    addClient(client);
    if (defaultClientName == "") {
      defaultClientName = client.name;
    }
    return client;
  }

  EzyClient newDefaultClient(EzyConfig config) {
    var client = newClient(config);
    defaultClientName = client.name;
    return client;
  }

  void addClient(EzyClient client) {
    clients[client.name] = client;
  }

  EzyClient? getClient(String clientName) {
    EzyClient? client = clients[clientName];
    return client;
  }

  EzyClient? getDefaultClient() {
    return clients[defaultClientName];
  }
}
