import 'dart:core';

class EzyConfig {
  String zoneName = "";
  String clientName;
  bool enableSSL = false;
  bool enableDebug = false;
  EzyPingConfig ping = EzyPingConfig();
  EzyReconnectConfig reconnect = EzyReconnectConfig();
  EzyConfig(this.clientName);
  String getClientName() {
    return clientName;
  }

  Map toMap() {
    Map map = {};
    map["clientName"] = getClientName();
    map["zoneName"] = zoneName;
    map["enableSSL"] = enableSSL;
    map["enableDebug"] = enableDebug;
    map["ping"] = ping.toMap();
    map["reconnect"] = reconnect.toMap();
    return map;
  }
}

class EzyPingConfig {
  int pingPeriod = 3000;
  int maxLostPingCount = 5;

  Map toMap() {
    Map map = {};
    map["pingPeriod"] = pingPeriod;
    map["maxLostPingCount"] = maxLostPingCount;
    return map;
  }
}

class EzyReconnectConfig {
  bool enable = true;
  int maxReconnectCount = 5;
  int reconnectPeriod = 3000;

  Map toMap() {
    Map map = {};
    map["enable"] = enable;
    map["maxReconnectCount"] = maxReconnectCount;
    map["reconnectPeriod"] = reconnectPeriod;
    return map;
  }
}
