// ignore_for_file: non_constant_identifier_names

import 'ezy_client.dart';
import 'ezy_config.dart';

class EzyClients {
  late String defaultClientName;
  late Map<String, EzyClient> clients;
  static final EzyClients _INSTANCE = EzyClients._();

  EzyClients._() {
    defaultClientName = "";
    clients = <String, EzyClient>{};
  }

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

  EzyClient getClient(String clientName) {
    var client = clients[clientName]!;
    return client;
  }

  EzyClient getDefaultClient() {
    return clients[defaultClientName]!;
  }
}
