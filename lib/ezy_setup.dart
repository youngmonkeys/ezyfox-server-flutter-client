import 'ezy_handlers.dart';
import 'ezy_managers.dart';

class EzySetup {
  late EzyHandlerManager handlerManager;
  late Map<String, EzyAppSetup> appSetupByAppName;

  EzySetup(EzyHandlerManager handlerManager) {
    this.handlerManager = handlerManager;
    this.appSetupByAppName = Map();
  }

  EzySetup addDataHandler(String cmd, EzyDataHandler handler) {
    this.handlerManager.addDataHandler(cmd, handler);
    return this;
  }

  EzySetup addEventHandler(String eventType, EzyEventHandler handler) {
    this.handlerManager.addEventHandler(eventType, handler);
    return this;
  }

  EzyAppSetup setupApp(String appName) {
    var appSetup = this.appSetupByAppName[appName];
    if(appSetup == null) {
      var appDataHandlers = this.handlerManager.getAppDataHandlers(appName);
      appSetup = EzyAppSetup(appDataHandlers, this);
      this.appSetupByAppName[appName] = appSetup;
    }
    return appSetup;
  }
}

class EzyAppSetup {
  late EzySetup parent;
  late EzyAppDataHandlers dataHandlers;

  EzyAppSetup(EzyAppDataHandlers dataHandlers, EzySetup parent) {
    this.parent = parent;
    this.dataHandlers = dataHandlers;
  }

  EzyAppSetup addDataHandler(String cmd, EzyAppDataHandler handler) {
    this.dataHandlers.addHandler(cmd, handler);
    return this;
  }

  EzySetup done() {
    return this.parent;
  }
}
