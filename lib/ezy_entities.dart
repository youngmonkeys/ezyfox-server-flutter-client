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

  EzyZone(EzyClient client, int id, String name) {
    this.client = client;
    this.id = id;
    this.name = name;
    this.appManager = EzyAppManager(name);
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

  EzyApp(EzyClient client, EzyZone zone, int id, String name) {
    this.id = id;
    this.name = name;
    this.client = client;
    this.zone = zone;
    this.dataHandlers = client.handlerManager.getAppDataHandlers(name);
  }

  void send(String cmd, [dynamic data = EMPTY_MAP, bool encrypted = false]) {
    var requestData = [];
    requestData.add(this.id);
    var requestParams = [];
    requestParams.add(cmd);
    requestParams.add(data);
    requestData.add(requestParams);
    this.client.send(EzyCommand.APP_REQUEST, requestData, encrypted);
  }

  EzyAppDataHandler? getDataHandler(String cmd) {
    return this.dataHandlers.getHandler(cmd);
  }
}

class EzyUser {
  late int id;
  late String name;

  EzyUser(int id, String name) {
    this.id = id;
    this.name = name;
  }
}
