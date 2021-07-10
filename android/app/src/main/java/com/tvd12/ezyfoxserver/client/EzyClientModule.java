package com.tvd12.ezyfoxserver.client;

import android.util.Log;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Map;
import com.tvd12.ezyfoxserver.client.exception.EzyMethodCallException;
import com.tvd12.ezyfoxserver.client.proxy.EzyConnectMethod;
import com.tvd12.ezyfoxserver.client.proxy.EzyCreateClientMethod;
import com.tvd12.ezyfoxserver.client.proxy.EzyDisconnectMethod;
import com.tvd12.ezyfoxserver.client.proxy.EzyMethodProxy;
import com.tvd12.ezyfoxserver.client.proxy.EzyReconnectMethod;
import com.tvd12.ezyfoxserver.client.proxy.EzySendMethod;
import com.tvd12.ezyfoxserver.client.proxy.EzySetStatusMethod;
import com.tvd12.ezyfoxserver.client.proxy.EzyStartPingScheduleMethod;

import java.util.HashMap;
import java.util.Map;

public class EzyClientModule extends ReactContextBaseJavaModule {

    private final Map<String, EzyMethodProxy> methods;

    public EzyClientModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.methods = new HashMap<>();
        this.init();
    }

    private void init() {
        addMethod(new EzyCreateClientMethod(getReactApplicationContext()));
        addMethod(new EzyConnectMethod());
        addMethod(new EzyReconnectMethod());
        addMethod(new EzyDisconnectMethod());
        addMethod(new EzySendMethod());
        addMethod(new EzySetStatusMethod());
        addMethod(new EzyStartPingScheduleMethod());
    }

    private void addMethod(EzyMethodProxy method) {
        methods.put(method.getName(), method);
    }

    @ReactMethod
    public void run(String method, Map params) {
        run2(method, params, null);
    }

    @ReactMethod
    public void run2(String method, Map params, Callback success) {
        run3(method, params, success, null);
    }

    @ReactMethod
    public void run3(String method, Map params, Callback success, Callback failure) {
        EzyMethodProxy func = methods.get(method);
        if(func == null)
            throw new IllegalArgumentException("has no method: " + method);
        try {
            func.validate(params);
            Object result = func.invoke(params);
            if(success != null)
                success.invoke(result);
        }
        catch (EzyMethodCallException e) {
            if(failure != null) {
                Log.w("ezyfox-client", "call method: " + method + " with params: " + params + " error: " + e.getMessage());
                failure.invoke(e.getCode(), e.getMessage());
            }
        }
        catch (Exception e) {
            Log.e("ezyfox-client", "fatal error when call method: " + method, e);
        }
    }

    @Override
    public Map<String, Object> getConstants() {
        Map<String, Object> constants = new HashMap<>();
        return constants;
    }

    @Override
    public String getName() {
        return "EzyClientProxy";
    }
}