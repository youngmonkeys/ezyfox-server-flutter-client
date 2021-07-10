package com.tvd12.ezyfoxserver.client.proxy;

import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.setup.EzySetup;
import com.tvd12.ezyfoxserver.client.config.EzyClientConfig;
import com.tvd12.ezyfoxserver.client.config.EzyReconnectConfig;
import com.tvd12.ezyfoxserver.client.constant.EzyCommand;
import com.tvd12.ezyfoxserver.client.constant.EzyConstant;
import com.tvd12.ezyfoxserver.client.entity.EzyArray;
import com.tvd12.ezyfoxserver.client.event.EzyEvent;
import com.tvd12.ezyfoxserver.client.event.EzyEventType;
import com.tvd12.ezyfoxserver.client.handler.EzyDataHandler;
import com.tvd12.ezyfoxserver.client.handler.EzyEventHandler;
import com.tvd12.ezyfoxserver.client.serializer.EzyNativeSerializers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

/**
 * Created by tavandung12 on 10/24/18.
 */

public class EzyCreateClientMethod extends EzyMethodProxy {

    private final MethodChannel methodChannel;

    public EzyCreateClientMethod(MethodChannel methodChannel) {
        this.methodChannel = methodChannel;
    }

    @Override
    public void validate(Map params) {
        if(params == null)
            throw new NullPointerException("the config is null, can't create an client");
        if(!params.containsKey("zoneName"))
            throw new IllegalArgumentException("must specific zone name");
    }

    @Override
    public Object invoke(Map params) {
        EzyClientConfig config = newConfig(params);
        EzyClient client = getClient(config.getClientName());
        if(client == null) {
            client = clients.newClient(config);
            setupClient(client);
        }
        Map configMap = EzyNativeSerializers.serialize(config);
        return configMap;
    }

    private EzyClientConfig newConfig(Map params) {
        EzyClientConfig.Builder configBuilder = EzyClientConfig.builder();
        if(params.containsKey("clientName"))
            configBuilder.clientName((String) params.get("clientName"));
        if(params.containsKey("zoneName"))
            configBuilder.zoneName((String) params.get("zoneName"));
        if(params.containsKey("reconnect")) {
            Map reconnect = (Map) params.get("reconnect");
            EzyReconnectConfig.Builder reconnectConfigBuilder = configBuilder.reconnectConfigBuilder();
            if (reconnect.containsKey("enable"))
                reconnectConfigBuilder.enable((Boolean) reconnect.get("enable"));
            if (reconnect.containsKey("reconnectPeriod"))
                reconnectConfigBuilder.reconnectPeriod((Integer) reconnect.get("reconnectPeriod"));
            if (reconnect.containsKey("maxReconnectCount"))
                reconnectConfigBuilder.maxReconnectCount((Integer) reconnect.get("maxReconnectCount"));
        }
        EzyClientConfig config = configBuilder.build();
        return config;
    }

    public void setupClient(EzyClient client) {
        EzySetup setup = client.setup();
        for(EzyEventType eventType : EzyEventType.values())
            setup.addEventHandler(eventType, new EzyNativeEventHandler(client, methodChannel));
        for(EzyCommand command : EzyCommand.values())
            setup.addDataHandler(command, new EzyNativeDataHandler(client, methodChannel, command));
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_INIT;
    }
}

class EzyNativeEventHandler implements EzyEventHandler<EzyEvent> {
    private final EzyClient client;
    private final MethodChannel methodChannel;

    public EzyNativeEventHandler(EzyClient client, MethodChannel methodChannel) {
        this.client = client;
        this.methodChannel = methodChannel;
    }

    @Override
    public void handle(EzyEvent event) {
        String eventTypeName = event.getType().getName();
        Map params = new HashMap<>();
        Map eventData = EzyNativeSerializers.serialize(event);
        params.put("clientName", client.getName());
        params.put("eventType", eventTypeName);
        params.put("data", eventData);
        methodChannel.invokeMethod("onSocketEvent", params);
    }
}

class EzyNativeDataHandler implements EzyDataHandler {
    private final EzyClient client;
    private final MethodChannel methodChannel;
    private final EzyConstant command;

    public EzyNativeDataHandler(EzyClient client,
                                MethodChannel methodChannel,
                                EzyConstant command) {
        this.client = client;
        this.methodChannel = methodChannel;
        this.command = command;
    }

    @Override
    public void handle(EzyArray data) {
        String commandName = command.getName();
        Map params = new HashMap<>();
        List commandData = EzyNativeSerializers.toList(data);
        params.put("clientName", client.getName());
        params.put("command", commandName);
        params.put("data", commandData);
        methodChannel.invokeMethod("onSocketData", params);
    }
}