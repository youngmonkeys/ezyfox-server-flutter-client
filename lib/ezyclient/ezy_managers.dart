import 'dart:developer';

import 'ezy_logger.dart';

import 'ezy_client.dart';
import 'ezy_constants.dart';
import 'ezy_entities.dart';
import 'ezy_handlers.dart';

class EzyAppManager {
  late String zoneName;
  late List<EzyApp> appList;
  late Map<int, EzyApp> appById;
  late Map<String, EzyApp> appByName;

  EzyAppManager(String zoneName) {
    this.zoneName = zoneName;
    this.appList = [];
    this.appById = Map();
    this.appByName = Map();
  }

  EzyApp? getApp() {
    if(appList.isEmpty) {
      EzyLogger.warn("there is no app in zone: $zoneName");
      return null;
    }
    return appList[0];
  }

  void addApp(EzyApp app) {
    this.appList.add(app);
    this.appById[app.id] = app;
    this.appByName[app.name] = app;
  }

  EzyApp? removeApp(int appId) {
    var app = appById[appId];
    if(app != null) {
      appList.remove(app);
      appById.remove(app.id);
      appByName.remove(app.name);
    }
  }

  EzyApp? getAppById(int appId) {
    return appById[appId];
  }

  EzyApp? getAppByName(String appName) {
    return appByName[appName];
  }
}

//===================================================
class EzyHandlerManager {

  late EzyClient client;
  late EzyDataHandlers dataHandlers;
  late EzyEventHandlers eventHandlers;
  late Map<String, EzyAppDataHandlers> appDataHandlersByAppName;

  EzyHandlerManager(EzyClient client) {
    this.client = client;
    this.appDataHandlersByAppName = Map<String, EzyAppDataHandlers>();
    this.dataHandlers = this._newDataHandlers();
    this.eventHandlers = this._newEventHandlers();
  }

  static EzyHandlerManager create(EzyClient client) {
    var pRet = EzyHandlerManager(client);
    return pRet;
  }

  EzyEventHandlers _newEventHandlers() {
    var handlers = EzyEventHandlers(client);
    handlers.addHandler(EzyEventType.CONNECTION_SUCCESS, EzyConnectionSuccessHandler());
    handlers.addHandler(EzyEventType.CONNECTION_FAILURE, EzyConnectionFailureHandler());
    handlers.addHandler(EzyEventType.DISCONNECTION, EzyDisconnectionHandler());
    return handlers;
  }

  EzyDataHandlers _newDataHandlers() {
    var handlers = EzyDataHandlers(client);
    handlers.addHandler(EzyCommand.PONG, EzyPongHandler());
    handlers.addHandler(EzyCommand.HANDSHAKE, EzyHandshakeHandler());
    handlers.addHandler(EzyCommand.LOGIN, EzyLoginSuccessHandler());
    handlers.addHandler(EzyCommand.LOGIN_ERROR, EzyLoginErrorHandler());
    handlers.addHandler(EzyCommand.APP_ACCESS, EzyAppAccessHandler());
    handlers.addHandler(EzyCommand.APP_EXIT, EzyAppExitHandler());
    handlers.addHandler(EzyCommand.APP_REQUEST, EzyAppResponseHandler());
    return handlers;
  }

  EzyDataHandler? getDataHandler(String cmd) {
    return dataHandlers.getHandler(cmd);
  }

  EzyEventHandler? getEventHandler(String eventType) {
    return eventHandlers.getHandler(eventType);
  }

  EzyAppDataHandlers getAppDataHandlers(String appName) {
    var answer = appDataHandlersByAppName[appName];
    if(answer == null) {
      answer = EzyAppDataHandlers();
      appDataHandlersByAppName[appName] = answer;
    }
    return answer;
  }

  void addDataHandler(String cmd, EzyDataHandler handler) {
    dataHandlers.addHandler(cmd, handler);
  }

  void addEventHandler(String eventType, EzyEventHandler handler) {
    eventHandlers.addHandler(eventType, handler);
  }
}
