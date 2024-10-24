import 'dart:core';

import 'ezy_client.dart';
import 'ezy_constants.dart';
import 'ezy_handlers.dart';
import 'ezy_managers.dart';

class EzyZone {
  late int id;
  late String name;
  late EzyClient client;
  late EzyAppManager appManager;

  EzyZone(this.client, this.id, this.name) {
    appManager = EzyAppManager(name);
  }

  EzyApp? getApp() {
    return appManager.getApp();
  }
}

class EzyApp {
  late int id;
  late String name;
  late EzyZone zone;
  late EzyClient client;
  late EzyAppDataHandlers dataHandlers;
  static const Map EMPTY_MAP = {};

  EzyApp(this.client, this.zone, this.id, this.name) {
    dataHandlers = client.handlerManager.getAppDataHandlers(name);
  }

  void send(String cmd, [dynamic data = EMPTY_MAP, bool encrypted = false]) {
    var requestData = [];
    requestData.add(id);
    var requestParams = [];
    requestParams.add(cmd);
    requestParams.add(data);
    requestData.add(requestParams);
    client.send(EzyCommand.APP_REQUEST, requestData, encrypted);
  }

  EzyAppDataHandler? getDataHandler(String cmd) {
    return dataHandlers.getHandler(cmd);
  }
}

class EzyUser {
  late int id;
  late String name;

  EzyUser(this.id, this.name);
}
