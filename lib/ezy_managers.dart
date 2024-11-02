import 'ezy_client.dart';
import 'ezy_constants.dart';
import 'ezy_entities.dart';
import 'ezy_handlers.dart';
import 'ezy_logger.dart';

class EzyAppManager {
  String zoneName;
  List<EzyApp> appList = [];
  Map<int, EzyApp> appById = {};
  Map<String, EzyApp> appByName = {};

  EzyAppManager(this.zoneName);

  EzyApp? getApp() {
    if (appList.isEmpty) {
      EzyLogger.warn("there is no app in zone: $zoneName");
      return null;
    }
    return appList[0];
  }

  void addApp(EzyApp app) {
    appList.add(app);
    appById[app.id] = app;
    appByName[app.name] = app;
  }

  EzyApp? removeApp(int appId) {
    EzyApp? app = appById[appId];
    if (app != null) {
      appList.remove(app);
      appById.remove(app.id);
      appByName.remove(app.name);
    }
    return app;
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
  EzyClient client;
  late EzyDataHandlers dataHandlers;
  late EzyEventHandlers eventHandlers;
  Map<String, EzyAppDataHandlers> appDataHandlersByAppName =
      <String, EzyAppDataHandlers>{};

  EzyHandlerManager(this.client) {
    dataHandlers = _newDataHandlers();
    eventHandlers = _newEventHandlers();
  }

  static EzyHandlerManager create(EzyClient client) {
    EzyHandlerManager pRet = EzyHandlerManager(client);
    return pRet;
  }

  EzyEventHandlers _newEventHandlers() {
    EzyEventHandlers handlers = EzyEventHandlers(client);
    handlers.addHandler(
        EzyEventType.CONNECTION_SUCCESS, EzyConnectionSuccessHandler());
    handlers.addHandler(
        EzyEventType.CONNECTION_FAILURE, EzyConnectionFailureHandler());
    handlers.addHandler(EzyEventType.DISCONNECTION, EzyDisconnectionHandler());
    return handlers;
  }

  EzyDataHandlers _newDataHandlers() {
    EzyDataHandlers handlers = EzyDataHandlers(client);
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
    EzyAppDataHandlers? answer = appDataHandlersByAppName[appName];
    if (answer == null) {
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
