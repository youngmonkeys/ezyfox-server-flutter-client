import 'package:flutter/services.dart';
import 'ezy_clients.dart';
import 'ezy_logger.dart';
import 'ezy_client.dart';

class EzyProxy {
  final MethodChannel _methodChannel =
      const MethodChannel('com.tvd12.ezyfoxserver.client');

  static final EzyProxy _INSTANCE = EzyProxy._();

  EzyProxy._() {
    _methodChannel.setMethodCallHandler(_handleSocketEventDatas);
  }

  static EzyProxy getInstance() {
    return _INSTANCE;
  }

  Future<void> _handleSocketEventDatas(MethodCall call) async {
    // type inference will work here avoiding an explicit cast
    switch (call.method) {
      case "ezy.event":
        _onSocketEvent(call.arguments);
        break;
      case "ezy.data":
        _onSocketData(call.arguments);
        break;
      default:
        EzyLogger.warn(
          "there is no handler for method: ${call.method}, ignore it",
        );
    }
  }

  void _onSocketEvent(Map arguments) {
    String? clientName = arguments["clientName"];
    String? eventType = arguments["eventType"];
    dynamic data = arguments["data"];
    if (clientName == null) {
      EzyLogger.warn("clientName is null, ignore event: $eventType");
      return;
    }
    EzyClient? client = _getClient(clientName);
    if (eventType == null) {
      EzyLogger.warn("Event type not found, client name: $clientName");
      return;
    }
    if (client == null) {
      EzyLogger.warn("Client not found, client name: $clientName");
      return;
    }
    client.handleEvent(eventType, data);
  }

  void _onSocketData(Map arguments) {
    String? clientName = arguments["clientName"];
    String? command = arguments["command"];
    dynamic data = arguments["data"];
    if (clientName == null) {
      EzyLogger.warn("clientName is null, ignore data: $command");
      return;
    }
    EzyClient? client = _getClient(clientName);
    if (client == null) {
      EzyLogger.warn("Client not found, client name: $clientName");
      return;
    }
    if (command == null) {
      EzyLogger.warn("Command not found, client name: $clientName");
      return;
    }
    client.handleData(command, data);
  }

  static Future<T?> run<T>(String method, Map params) {
    return EzyProxy.getInstance()._methodChannel.invokeMethod(method, params);
  }

  EzyClient? _getClient(String clientName) {
    return EzyClients.getInstance().getClient(clientName);
  }
}
