import 'dart:developer';

import 'ezy_proxy.dart';

class EzyLogger {
  EzyLogger._();

  static void error(String message) {
    Map params = {
      "level": "e",
      "message": message
    };
    EzyProxy.run("log", params);
  }

  static void warn(String message) {
    Map params = {
      "level": "w",
      "message": message
    };
    EzyProxy.run("log", params);
  }

  static void info(String message) {
    Map params = {
      "level": "i",
      "message": message
    };
    EzyProxy.run("log", params);
  }
}