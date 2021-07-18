package com.tvd12.ezyfoxerver.client.proxy;

import com.tvd12.ezyfoxerver.client.EzyMethodNames;
import com.tvd12.ezyfoxerver.client.serializer.EzyNativeSerializers;
import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.constant.EzyCommand;
import com.tvd12.ezyfoxserver.client.entity.EzyArray;

import java.util.List;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzySendMethod extends EzyMethodProxy {
    @Override
    public void validate(Map params) {
        if(!params.containsKey("request"))
            throw new IllegalArgumentException("must specific request to send to server");
    }

    @Override
    public Object invoke(Map params) {
        EzyClient client = getClient(params);
        Map request = (Map) params.get("request");
        String cmd = (String) request.get("command");
        List data = (List) request.get("data");
        boolean encrypted = (Boolean)request.getOrDefault("encrypted", false);
        EzyArray array = EzyNativeSerializers.fromList(data);
        client.send(EzyCommand.valueOf(cmd), array, encrypted);
        return Boolean.TRUE;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_SEND;
    }
}
