import 'dart:core';

import 'ezy_client.dart';
import 'ezy_constants.dart';
import 'ezy_handlers.dart';
import 'ezy_managers.dart';

class EzyZone {
  int id;
  String name;
  EzyClient client;
  late EzyAppManager appManager;

  EzyZone(this.client, this.id, this.name) {
    appManager = EzyAppManager(name);
  }

  EzyApp? getApp() {
    return appManager.getApp();
  }
}

class EzyApp {
  int id;
  String name;
  EzyZone zone;
  EzyClient client;
  late EzyAppDataHandlers dataHandlers;
  static const Map EMPTY_MAP = {};

  EzyApp(
      {required this.client,
      required this.zone,
      required this.id,
      required this.name}) {
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
  int id;
  String name;

  EzyUser({required this.id, required this.name});
}
