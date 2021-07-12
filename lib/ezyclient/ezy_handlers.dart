import 'dart:core';
import 'dart:typed_data';

import 'ezy_client.dart';
import 'ezy_constants.dart';
import 'ezy_entities.dart';
import 'ezy_logger.dart';
import 'ezy_util.dart';

class EzyEventHandler {
  void handle(Map event) {}
}

class EzyDataHandler {
  void handle(List data) {}
}

class EzyAbstractEventHandler extends EzyEventHandler{
  late EzyClient client;
}

class EzyAbstractDataHandler extends EzyDataHandler {
  late EzyClient client;
}

class EzyAppDataHandler<T> {
  void handle(EzyApp app, T data) {}
}

class EzyAbstractAppDataHandler<T> implements EzyAppDataHandler<T> {

  @override
  void handle(EzyApp app, T data) {
    process(app, data);
  }

  void process(EzyApp app, T data) {}
}

class EzyConnectionSuccessHandler extends EzyAbstractEventHandler {
  var clientType = "FLUTTER";
  var clientVersion = "1.0.0";

  void handle(Map event) {
    this.sendHandshakeRequest();
    this.postHandle();
  }

  void postHandle() {
  }

  void sendHandshakeRequest() {
    var request = newHandshakeRequest();
    this.client.send(EzyCommand.HANDSHAKE, request);
  }

  List newHandshakeRequest() {
    var clientId = this.getClientId();
    var clientKey = this.generateClientKey();
    var enableEncryption = this.client.enableSSL;
    var token = this.getStoredToken();
    var request = [];
    request.add(clientId);
    request.add(clientKey);
    request.add(clientType);
    request.add(clientVersion);
    request.add(enableEncryption);
    request.add(token);
    return request;
  }

  String? generateClientKey() {
    if(client.enableSSL) {
      // var keyPair = EzyRSAProxy.getInstance().generateKeyPair()
      // client.privateKey = keyPair.privateKey;
      // return keyPair.publicKey;
    }
    return null;
  }

  String getClientId() {
    return UUID.random();
  }

  String getStoredToken() {
    return "";
  }

}

//=======================================================
class EzyConnectionFailureHandler extends EzyAbstractEventHandler {

  @override
  void handle(Map event) {
    var reason = event["reason"] as int;
    var reasonName = EzyConnectionFailedReasons.getConnectionFailedReasonName(reason);
    EzyLogger.warn("connection failure, reason = \(reasonName)");
    var config = this.client.config;
    var reconnectConfig = config.reconnect;
    var should = this.shouldReconnect(event);
    var reconnectEnable = reconnectConfig.enable;
    var mustReconnect = reconnectEnable && should;
    this.client.setStatus(EzyConnectionStatus.FAILURE);
    if(mustReconnect) {
      client.reconnect().then((value) => {
        if(value) {
          control(event)
        }
      });
    }
  }

  bool shouldReconnect(Map event) {
    return true;
  }

  void control(Map event) {}
}

//=======================================================
class EzyDisconnectionHandler extends EzyAbstractEventHandler {

  @override
  void handle(Map event) {
    var reason = event["reason"] as int;
    var reasonName = EzyDisconnectReasons.getDisconnectReasonName(reason);
    EzyLogger.info("handle disconnection, reason = $reasonName");
    preHandle(event);
    var config = this.client.config;
    var reconnectConfig = config.reconnect;
    var should = this.shouldReconnect(event);
    var reconnectEnable = reconnectConfig.enable;
    var mustReconnect = reconnectEnable &&
      reason != EzyDisconnectReason.UNAUTHORIZED &&
      reason != EzyDisconnectReason.CLOSE &&
      should;
    this.client.setStatus(EzyConnectionStatus.DISCONNECTED);
    if(mustReconnect) {
      client.reconnect().then((value) => {
        if(value) {
          control(event)
        }
      });
    }
  }

  void preHandle(Map event) {}

  bool shouldReconnect(Map event) {
    var reason = event["reason"] as int;
    if(reason == EzyDisconnectReason.ANOTHER_SESSION_LOGIN) {
      return false;
    }
    return true;
  }

  void control(Map event) {
  }

  void postHandle(Map event) {
  }
}

//=======================================================
class EzyPongHandler extends EzyAbstractDataHandler {
}

//=======================================================

class EzyHandshakeHandler extends EzyAbstractDataHandler {

  void handle(List data) {
    this.startPing();
    if(this.doHandle(data)) {
      this.handleLogin();
    }
    this.postHandle(data);
  }

  bool doHandle(List data) {
    client.sessionToken = data[1] as String;
    client.sessionId = data[2] as int;
    if(client.enableSSL) {
    var sessionKey = decrypteSessionKey(data[3]);
    if(sessionKey == null) {
      return false;
    }
    client.setSessionKey(sessionKey);
    }
    return true;
  }

  Uint8List? decrypteSessionKey(Uint8List? encyptedSessionKey) {
    if(encyptedSessionKey == null) {
      if(client.enableDebug) {
        return Uint8List(0);
      }
      EzyLogger.error("maybe server was not enable SSL, you must enable SSL on server or disable SSL on your client or enable debug mode");
      client.close();
      return null;
    }
    var privateKey = client.privateKey;
    // return EzyRSAProxy.getInstance().decrypt(encyptedSessionKey, privateKey);
    return null;
  }

  void postHandle(List data) {
  }

  void handleLogin() {
    var loginRequest = this.getLoginRequest();
    this.client.send(EzyCommand.LOGIN, loginRequest, encryptedLoginRequest());
  }

  bool encryptedLoginRequest() {
    return false;
  }

  List getLoginRequest() {
    var array = [];
    array.add("test");
    array.add("test");
    array.add("test");
    array.add([]);
    return array;
  }

  void startPing() {
    this.client.startPingSchedule();
  }
}

//=======================================================
class EzyLoginSuccessHandler extends EzyAbstractDataHandler {

  @override
  void handle(List data) {
    var responseData = data[4];
    var user = newUser(data);
    var zone = newZone(data);
    this.client.me = user;
    this.client.zone = zone;
    this.handleLoginSuccess(responseData);
    EzyLogger.info("user: ${user.name} logged in successfully");
  }

  EzyUser newUser(List data) {
    var userId = data[2] as int;
    var username = data[3] as String;
    var user = EzyUser(userId, username);
    return user;
  }

  EzyZone newZone(List data) {
    var zoneId = data[0] as int;
    var zoneName = data[1] as String;
    var zone = EzyZone(this.client, zoneId, zoneName);
    return zone;
  }
  
  void handleLoginSuccess(dynamic responseData) {}
}

//=======================================================
class EzyLoginErrorHandler extends EzyAbstractDataHandler {

  @override
  void handle(List data) {
    this.client.disconnect(EzyDisconnectReason.UNAUTHORIZED);
    this.handleLoginError(data);
  }

  void handleLoginError(List data) {}
}

//=======================================================
class EzyAppAccessHandler extends EzyAbstractDataHandler {

  @override
  void handle(List data) {
    var zone = this.client.zone;
    var appManager = zone!.appManager;
    var app = this.newApp(zone, data);
    appManager.addApp(app);
    this.postHandle(app, data);
    EzyLogger.info("access app: ${app.name} successfully");
  }
  
  EzyApp newApp(EzyZone zone, List data) {
    var appId = data[0] as int;
    var appName = data[1] as String;
    var app = EzyApp(client, zone, appId, appName);
    return app;
  }
  
  void postHandle(EzyApp app, List data) {}
}

//=======================================================
class EzyAppExitHandler extends EzyAbstractDataHandler {

  @override
  void handle(List data) {
    var zone = this.client.zone;
    var appManager = zone!.appManager;
    var appId = data[0] as int;
    var reasonId = data[1] as int;
    var app = appManager.removeApp(appId);
    if(app != null) {
      this.postHandle(app, data);
      EzyLogger.info("user exit app: ${app.name}, reason: $reasonId");
    }
  }
  
  void postHandle(EzyApp app, List data) {}
}

//=======================================================
class EzyAppResponseHandler extends EzyAbstractDataHandler {

  @override
  void handle(List data) {
    var appId = data[0] as int;
    var responseData = data[1] as List;
    var cmd = responseData[0];
    var commandData = responseData[1] as Map;

    var app = this.client.getAppById(appId)!;
    if(app == null) {
      EzyLogger.info("receive message when has not joined app yet");
      return;
    }
    var handler = app.getDataHandler(cmd);
    if(handler != null) {
      handler.handle(app, commandData);
    }
    else {
      EzyLogger.warn("app: ${app.name} has no handler for command: $cmd");
    }
  }
}

//=======================================================
class EzyEventHandlers {
  late EzyClient client;
  late Map handlers;

  EzyEventHandlers(EzyClient client) {
    this.client = client;
    this.handlers = Map();
  }

  void addHandler(String eventType, EzyEventHandler handler) {
    var abs = handler as EzyAbstractEventHandler;
    abs.client = this.client;
    this.handlers[eventType] = handler;
  }

  EzyEventHandler? getHandler(String eventType) {
    return this.handlers[eventType];
  }

  void handle(String eventType, Map data) {
    var handler = this.getHandler(eventType);
    if(handler != null) {
        handler.handle(data);
    }
    else {
      EzyLogger.warn("has no handler with event: $eventType");
    }
  }
}

//=======================================================

class EzyDataHandlers {
  late EzyClient client;
  late Map handlerByCommand;

  EzyDataHandlers(EzyClient client) {
    this.client = client;
    this.handlerByCommand = Map();
  }
  
  void addHandler(String cmd, EzyDataHandler handler) {
    var abs = handler as EzyAbstractDataHandler;
    abs.client = this.client;
    this.handlerByCommand[cmd] = handler;
  }

  EzyDataHandler? getHandler(String cmd) {
    return this.handlerByCommand[cmd];
  }
  
  void handle(String cmd, dynamic data) {
    var handler = this.getHandler(cmd);
    if(handler != null) {
      handler.handle(data);
    }
    else {
      EzyLogger.warn("has no handler with command: $cmd");
    }
  }
}

//=======================================================

class EzyAppDataHandlers {
  late Map<String, EzyAppDataHandler> _handlerByAppName;

  EzyAppDataHandlers() {
    this._handlerByAppName = Map();
  }

  void addHandler(String cmd, EzyAppDataHandler handler) {
    this._handlerByAppName[cmd] = handler;
  }

  EzyAppDataHandler? getHandler(String cmd) {
    return  this._handlerByAppName[cmd];
  }
}
