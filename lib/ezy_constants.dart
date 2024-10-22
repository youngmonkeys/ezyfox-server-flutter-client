// ignore_for_file: constant_identifier_names

class EzyCommand {
  EzyCommand._();

  static const ERROR = "ERROR";
  static const HANDSHAKE = "HANDSHAKE";
  static const PING = "PING";
  static const PONG = "PONG";
  static const LOGIN = "LOGIN";
  static const LOGIN_ERROR = "LOGIN_ERROR";
  static const LOGOUT = "LOGOUT";
  static const APP_ACCESS = "APP_ACCESS";
  static const APP_REQUEST = "APP_REQUEST";
  static const APP_EXIT = "APP_EXIT";
  static const APP_ACCESS_ERROR = "APP_ACCESS_ERROR";
  static const APP_REQUEST_ERROR = "APP_REQUEST_ERROR";
  static const PLUGIN_INFO = "PLUGIN_INFO";
  static const PLUGIN_REQUEST = "PLUGIN_REQUEST";
}

class EzyEventType {
  EzyEventType._();

  static const CONNECTION_SUCCESS = "CONNECTION_SUCCESS";
  static const CONNECTION_FAILURE = "CONNECTION_FAILURE";
  static const DISCONNECTION = "DISCONNECTION";
  static const LOST_PING = "LOST_PING";
  static const TRY_CONNECT = "TRY_CONNECT";
}

class EzyConnectionStatus {
  EzyConnectionStatus._();

  static const NULL = "NULL";
  static const CONNECTING = "CONNECTING";
  static const CONNECTED = "CONNECTED";
  static const DISCONNECTED = "DISCONNECTED";
  static const FAILURE = "FAILURE";
  static const RECONNECTING = "RECONNECTING";
}

class EzyDisconnectReason {
  EzyDisconnectReason._();

  static const CLOSE = -1;
  static const UNKNOWN = 0;
  static const IDLE = 1;
  static const NOT_LOGGED_IN = 2;
  static const ANOTHER_SESSION_LOGIN = 3;
  static const ADMIN_BAN = 4;
  static const ADMIN_KICK = 5;
  static const MAX_REQUEST_PER_SECOND = 6;
  static const MAX_REQUEST_SIZE = 7;
  static const SERVER_ERROR = 8;
  static const SERVER_NOT_RESPONDING = 400;
  static const UNAUTHORIZED = 401;
}

class EzyDisconnectReasons {
  static const _REASON_NAMES = {
    EzyDisconnectReason.CLOSE: "CLOSE",
    EzyDisconnectReason.UNKNOWN: "UNKNOWN",
    EzyDisconnectReason.IDLE: "IDLE",
    EzyDisconnectReason.NOT_LOGGED_IN: "NOT_LOGGED_IN",
    EzyDisconnectReason.ANOTHER_SESSION_LOGIN: "ANOTHER_SESSION_LOGIN",
    EzyDisconnectReason.ADMIN_BAN: "ADMIN_BAN",
    EzyDisconnectReason.ADMIN_KICK: "ADMIN_KICK",
    EzyDisconnectReason.MAX_REQUEST_PER_SECOND: "MAX_REQUEST_PER_SECOND",
    EzyDisconnectReason.MAX_REQUEST_SIZE: "MAX_REQUEST_SIZE",
    EzyDisconnectReason.SERVER_ERROR: "SERVER_ERROR",
    EzyDisconnectReason.SERVER_NOT_RESPONDING: "SERVER_NOT_RESPONDING",
    EzyDisconnectReason.UNAUTHORIZED: "UNAUTHORIZED"
  };

  EzyDisconnectReasons._();

  static String getDisconnectReasonName(int reasonId) {
    return _REASON_NAMES[reasonId] ?? reasonId.toString();
  }
}

class EzyConnectionFailedReason {
  EzyConnectionFailedReason._();

  static const TIMEOUT = 0;
  static const NETWORK_UNREACHABLE = 1;
  static const UNKNOWN_HOST = 2;
  static const CONNECTION_REFUSED = 3;
  static const UNKNOWN = 4;
}

class EzyConnectionFailedReasons {
  static const _REASON_NAMES = {
    EzyConnectionFailedReason.TIMEOUT: "TIMEOUT",
    EzyConnectionFailedReason.NETWORK_UNREACHABLE: "NETWORK_UNREACHABLE",
    EzyConnectionFailedReason.UNKNOWN_HOST: "UNKNOWN_HOST",
    EzyConnectionFailedReason.CONNECTION_REFUSED: "CONNECTION_REFUSED",
    EzyConnectionFailedReason.UNKNOWN: "UNKNOWN"
  };
  EzyConnectionFailedReasons._();

  static String getConnectionFailedReasonName(int reasonId) {
    return _REASON_NAMES[reasonId] ?? reasonId.toString();
  }
}
