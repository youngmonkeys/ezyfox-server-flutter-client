import 'ezy_handlers.dart';
import 'ezy_managers.dart';

class EzySetup {
  EzyHandlerManager handlerManager;
  Map<String, EzyAppSetup> appSetupByAppName = {};

  EzySetup(this.handlerManager);

  EzySetup addDataHandler(String cmd, EzyDataHandler handler) {
    handlerManager.addDataHandler(cmd, handler);
    return this;
  }

  EzySetup addEventHandler(String eventType, EzyEventHandler handler) {
    handlerManager.addEventHandler(eventType, handler);
    return this;
  }

  EzyAppSetup setupApp(String appName) {
    EzyAppSetup? appSetup = appSetupByAppName[appName];
    if (appSetup == null) {
      var appDataHandlers = handlerManager.getAppDataHandlers(appName);
      appSetup = EzyAppSetup(appDataHandlers, this);
      appSetupByAppName[appName] = appSetup;
    }
    return appSetup;
  }
}

class EzyAppSetup {
  EzySetup parent;
  EzyAppDataHandlers dataHandlers;

  EzyAppSetup(this.dataHandlers, this.parent);

  EzyAppSetup addDataHandler(String cmd, EzyAppDataHandler handler) {
    dataHandlers.addHandler(cmd, handler);
    return this;
  }

  EzySetup done() {
    return parent;
  }
}
