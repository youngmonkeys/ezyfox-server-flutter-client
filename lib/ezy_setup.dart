// ignore_for_file: prefer_collection_literals

import 'ezy_handlers.dart';
import 'ezy_managers.dart';

class EzySetup {
  late EzyHandlerManager handlerManager;
  late Map<String, EzyAppSetup> appSetupByAppName;

  EzySetup(this.handlerManager) {
    appSetupByAppName = Map();
  }

  EzySetup addDataHandler(String cmd, EzyDataHandler handler) {
    handlerManager.addDataHandler(cmd, handler);
    return this;
  }

  EzySetup addEventHandler(String eventType, EzyEventHandler handler) {
    handlerManager.addEventHandler(eventType, handler);
    return this;
  }

  EzyAppSetup setupApp(String appName) {
    var appSetup = appSetupByAppName[appName];
    if (appSetup == null) {
      var appDataHandlers = handlerManager.getAppDataHandlers(appName);
      appSetup = EzyAppSetup(appDataHandlers, this);
      appSetupByAppName[appName] = appSetup;
      // add more

    }
    return appSetup;
  }
}

class EzyAppSetup {
  late EzySetup parent;
  late EzyAppDataHandlers dataHandlers;

  EzyAppSetup(this.dataHandlers, this.parent);

  EzyAppSetup addDataHandler(String cmd, EzyAppDataHandler handler) {
    dataHandlers.addHandler(cmd, handler);
    return this;
  }

  EzySetup done() {
    return parent;
  }
}
