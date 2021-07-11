package com.tvd12.ezyfoxserver.client;

import android.util.Log;

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
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class EzyClientModule {

    private MethodChannel methodChannel;
    private final AtomicBoolean registered;
    private final Map<String, EzyMethodProxy> methods;

    public static final String CHANNEL = "com.tvd12.ezyfoxserver.client";
    private static final EzyClientModule INSTANCE = new EzyClientModule();

    private EzyClientModule() {
        this.methods = new HashMap<>();
        this.registered = new AtomicBoolean(false);
    }

    public static EzyClientModule getInstance() {
        return INSTANCE;
    }

    public void register(BinaryMessenger messenger) {
        if(registered.compareAndSet(false, true)) {
            doRegister(messenger);
        }
    }

    private void doRegister(BinaryMessenger messenger) {
        methodChannel = new MethodChannel(
                messenger,
                CHANNEL
        );
        methodChannel.setMethodCallHandler((call, result) -> {
            Map args = (Map)call.arguments;
            int methodType = (Integer)args.getOrDefault("ezy.method_type", 1);
            if(methodType <= 1) {
                run(call.method, args);
            }
            else {
                runWithCallback(call.method, args, result);
            }
        });
        this.addDefaultMethods();
    }

    public void run(String method, Map params) {
        runWithCallback(method, params, null);
    }

    public void runWithCallback(String method, Map params, MethodChannel.Result callback) {
        EzyMethodProxy func = methods.get(method);
        if(func == null)
            throw new IllegalArgumentException("has no method: " + method);
        try {
            func.validate(params);
            Object result = func.invoke(params);
            if(callback != null)
                callback.success(result);
        }
        catch (EzyMethodCallException e) {
            if(callback != null) {
                Log.w("ezyfox-client", "call method: " + method + " with params: " + params + " error: " + e.getMessage());
                callback.error(e.getCode(), e.getMessage(), e.toString());
            }
        }
        catch (Exception e) {
            Log.e("ezyfox-client", "fatal error when call method: " + method, e);
        }
    }

    private void addDefaultMethods() {
        addMethod(new EzyCreateClientMethod(methodChannel));
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
}