import 'package:ezyfox_server_flutter_client/ezy_client.dart';
import 'package:ezyfox_server_flutter_client/ezy_clients.dart';
import 'package:ezyfox_server_flutter_client/ezy_config.dart';
import 'package:ezyfox_server_flutter_client/ezy_constants.dart';
import 'package:ezyfox_server_flutter_client/ezy_entities.dart';
import 'package:ezyfox_server_flutter_client/ezy_handlers.dart';

const ZONE_NAME = "example";
const APP_NAME = "hello-world";

class SocketProxy {
  bool settedUp = false;
  late String username;
  late String password;
  late EzyClient _client;
  late Function(String)? _greetCallback;
  late Function(String)? _secureChatCallback;
  late Function? _disconnectedCallback;
  late Function? _connectionFailedCallback;
  static final SocketProxy _INSTANCE = SocketProxy._();

  SocketProxy._() {}

  static SocketProxy getInstance() {
    return _INSTANCE;
  }

  void _setup() {
    EzyConfig config = EzyConfig();
    config.clientName = ZONE_NAME;
    config.enableSSL = true;
    config.ping.maxLostPingCount = 3;
    config.ping.pingPeriod = 1000;
    config.reconnect.maxReconnectCount = 10;
    config.reconnect.reconnectPeriod = 1000;
    // config.enableDebug = true;
    EzyClients clients = EzyClients.getInstance();
    _client = clients.newDefaultClient(config);
    _client.setup.addEventHandler(EzyEventType.DISCONNECTION, _DisconnectionHandler(_disconnectedCallback!));
    _client.setup.addEventHandler(EzyEventType.CONNECTION_FAILURE, _ConnectionFailureHandler(_disconnectedCallback!));
    _client.setup.addDataHandler(EzyCommand.HANDSHAKE, _HandshakeHandler());
    _client.setup.addDataHandler(EzyCommand.LOGIN, _LoginSuccessHandler());
    _client.setup.addDataHandler(EzyCommand.APP_ACCESS, _AppAccessHandler());
    var appSetup = _client.setup.setupApp(APP_NAME);
    appSetup.addDataHandler("greet", _GreetResponseHandler((message) {
      _greetCallback!(message);
    }));
    appSetup.addDataHandler("secureChat", _SecureChatResponseHandler((message) {
      _secureChatCallback!(message);
    }));
  }

  void connectToServer(String username, String password) {
    if(!settedUp) {
      settedUp = true;
      _setup();
    }
    this.username = username;
    this.password = password;
    // this._client.connect("127.0.0.1", 3005);
    this._client.connect("192.168.1.151", 3005);
    // this._client.connect("tvd12.com", 3005);
  }

  void onGreet(Function(String) callback) {
    this._greetCallback = callback;
  }

  void onSecureChat(Function(String) callback) {
    this._secureChatCallback = callback;
  }

  void onDisconnected(Function callback) {
    this._disconnectedCallback = callback;
  }

  void onConnectionFailed(Function callback) {
    this._connectionFailedCallback = callback;
  }
}

class _HandshakeHandler extends EzyHandshakeHandler {
  @override
  List getLoginRequest() {
    var request = [];
    request.add(ZONE_NAME);
    request.add(SocketProxy.getInstance().username);
    request.add(SocketProxy.getInstance().password);
    request.add([]);
    return request;
  }
}

class _LoginSuccessHandler extends EzyLoginSuccessHandler {
  @override
  void handleLoginSuccess(responseData) {
    client.send(EzyCommand.APP_ACCESS, [APP_NAME]);
  }
}

class _AppAccessHandler extends EzyAppAccessHandler {
  @override
  void postHandle(EzyApp app, List data) {
    app.send("greet", {"who": "Flutter's developer"});
  }
}

class _GreetResponseHandler extends EzyAppDataHandler<Map> {

  late Function(String) _callback;

  _GreetResponseHandler(Function(String) callback) {
    _callback = callback;
  }

  @override
  void handle(EzyApp app, Map data) {
    _callback(data["message"]);
    app.send("secureChat", {"who": "Young Monkey"}, true);
  }
}

class _SecureChatResponseHandler extends EzyAppDataHandler<Map> {

  late Function(String) _callback;

  _SecureChatResponseHandler(Function(String) callback) {
    _callback = callback;
  }

  @override
  void handle(EzyApp app, Map data) {
    _callback(data["secure-message"]);
  }
}

class _DisconnectionHandler extends EzyDisconnectionHandler {
  late Function _callback;

  _DisconnectionHandler(Function callback) {
    _callback = callback;
  }
  @override
  void postHandle(Map event) {
    _callback();
  }
}


class _ConnectionFailureHandler extends EzyConnectionFailureHandler {
  late Function _callback;

  _ConnectionFailureHandler(Function callback) {
    _callback = callback;
  }

  @override
  void onConnectionFailed(Map event) {
    _callback();
  }
}