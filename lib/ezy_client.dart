import 'dart:typed_data';

import 'ezy_config.dart';
import 'ezy_constants.dart';
import 'ezy_entities.dart';
import 'ezy_logger.dart';
import 'ezy_managers.dart';
import 'ezy_proxy.dart';
import 'ezy_setup.dart';

class EzyClient {
  late bool enableSSL;
  late bool enableDebug;
  late EzyConfig config;
  late String name;
  late EzyZone? zone;
  late EzyUser? me;
  late EzySetup setup;
  late EzyHandlerManager handlerManager;
  late Uint8List? privateKey;
  late int sessionId;
  late String? sessionToken;
  late Uint8List? sessionKey;

  EzyClient(this.config) {
    EzyProxy.run("init", config.toMap());
    name = config.getClientName();
    enableSSL = config.enableSSL;
    enableDebug = config.enableDebug;
    handlerManager = EzyHandlerManager.create(this);
    setup = EzySetup(handlerManager);
  }

  void connect(String host, int port) {
    privateKey = null;
    sessionKey = null;
    var params = Map();
    params["clientName"] = name;
    params["host"] = host;
    params["port"] = port;
    EzyProxy.run("connect", params);
  }

  Future reconnect() {
    privateKey = null;
    sessionKey = null;
    var params = Map();
    params["clientName"] = name;
    return EzyProxy.run("reconnect", params);
  }

  void disconnect([int reason = EzyDisconnectReason.CLOSE]) {
    var params = Map();
    params["clientName"] = name;
    params["reason"] = reason;
    EzyProxy.run("disconnect", params);
  }

  void close() {
    disconnect();
  }

  void send(String cmd, dynamic data, [bool encrypted = false]) {
    var shouldEncrypted = encrypted;
    if (encrypted && sessionKey == null) {
      if (enableDebug) {
        shouldEncrypted = false;
      } else {
        EzyLogger.error(
          "can not send command: $cmd, you must enable SSL "
          "or enable debug mode by configuration when you create the client",
        );
        return;
      }
    }
    var params = Map();
    params["clientName"] = name;
    var requestParams = Map();
    requestParams["command"] = cmd;
    requestParams["data"] = data;
    requestParams["encrypted"] = shouldEncrypted;
    params["request"] = requestParams;
    EzyProxy.run("send", params);
  }

  void startPingSchedule() {
    var params = Map();
    params["clientName"] = name;
    EzyProxy.run("startPingSchedule", params);
  }

  void setStatus(String status) {
    var params = Map();
    params["clientName"] = name;
    params["status"] = status;
    EzyProxy.run("setStatus", params);
  }

  void setSessionKey(Uint8List sessionKey) {
    this.sessionKey = sessionKey;
    var params = Map();
    params["clientName"] = name;
    params["sessionKey"] = sessionKey;
    EzyProxy.run("setSessionKey", params);
  }

  EzyApp? getApp() {
    if (zone != null) {
      var appManager = zone!.appManager;
      var app = appManager.getApp();
      return app;
    }
    return null;
  }

  EzyApp? getAppById(int appId) {
    if (zone != null) {
      var appManager = zone!.appManager;
      var app = appManager.getAppById(appId);
      return app;
    }
    return null;
  }

  void handleEvent(String eventType, Map data) {
    var eventHandlers = handlerManager.eventHandlers;
    eventHandlers.handle(eventType, data);
  }

  void handleData(String command, List data) {
    var dataHandlers = handlerManager.dataHandlers;
    dataHandlers.handle(command, data);
  }
}
