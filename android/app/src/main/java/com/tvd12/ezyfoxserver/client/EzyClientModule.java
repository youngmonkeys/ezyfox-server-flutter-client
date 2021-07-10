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

import io.flutter.plugin.common.MethodChannel;

public class EzyClientModule {

    private final MethodChannel methodChannel;
    private final Map<String, EzyMethodProxy> methods;

    public EzyClientModule(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
        this.methods = new HashMap<>();
        this.addDefaultMethods();
    }

    public void run(String method, Map params) {
        run2(method, params, null);
    }

    public void run2(String method, Map params, MethodChannel.Result success) {
        run3(method, params, success, null);
    }

    public void run3(
            String method,
            Map params,
            MethodChannel.Result success, MethodChannel.Result failure) {
        EzyMethodProxy func = methods.get(method);
        if(func == null)
            throw new IllegalArgumentException("has no method: " + method);
        try {
            func.validate(params);
            Object result = func.invoke(params);
            if(success != null)
                success.success(result);
        }
        catch (EzyMethodCallException e) {
            if(failure != null) {
                Log.w("ezyfox-client", "call method: " + method + " with params: " + params + " error: " + e.getMessage());
                failure.success(e.toDataMap());
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