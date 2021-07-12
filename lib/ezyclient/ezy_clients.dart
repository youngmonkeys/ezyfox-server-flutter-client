import 'package:hello_flutter/ezyclient/ezy_proxy.dart';

import 'ezy_client.dart';
import 'ezy_config.dart';
import 'ezy_logger.dart';

class EzyClients {
  late bool started;
  late String defaultClientName;
  late Map<String, EzyClient> clients;
  static EzyClients _INSTANCE = EzyClients();

  EzyClients() {
    this.started = false;
    this.defaultClientName = "";
    this.clients = Map();
  }

  static EzyClients getInstance() {
    return _INSTANCE;
  }

  EzyClient newClient(EzyConfig config) {
    var client =  EzyClient(config);
    this.addClient(client);
    if(defaultClientName == "") {
      defaultClientName = client.name;
    }
    return client;
  }
    
  EzyClient newDefaultClient(EzyConfig config) {
    var client = this.newClient(config);
    this.defaultClientName = client.name;
    return client;
  }

  void addClient(EzyClient client) {
    this.clients[client.name] = client;
  }

  EzyClient getClient(String clientName) {
    var client = this.clients[clientName]!;
    return client;
  }

  EzyClient getDefaultClient() {
    return this.clients[defaultClientName]!;
  }

  void processEvents() {
    if(started) {
      EzyLogger.info("clients has already started");
    }
    else {
      started = true;
      startEventsLoop();
    }
  }

  void startEventsLoop() {
    EzyProxy.run("processEvents", {});
  }
}
