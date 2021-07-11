import 'package:flutter/services.dart';

class EzyProxy {
  static const MethodChannel _methodChannel = const MethodChannel('com.tvd12.ezyfoxserver.client');

  EzyProxy._();

  static Future<T?> run<T>(String method, Map params) {
    return _methodChannel.invokeMethod(method, params);
  }
}