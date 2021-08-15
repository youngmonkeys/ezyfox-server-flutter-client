package com.tvd12.ezyfoxserver.client.flutter.proxy;

import com.tvd12.ezyfoxserver.client.flutter.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.EzyClient;

import java.util.Map;

/**
 * Created by tavandung12 on 10/24/18.
 */

public class EzyConnectMethod extends EzyMethodProxy {

    @Override
    public void validate(Map params) {
        if(!params.containsKey("host"))
            throw new IllegalArgumentException("must specific host");
        if(!params.containsKey("port"))
            throw new IllegalArgumentException("must specific port");
    }

    @Override
    public Object invoke(Map params) {
        String host = (String) params.get("host");
        int port = (int) params.get("port");
        EzyClient client = getClient(params);
        client.connect(host, port);
        return Boolean.TRUE;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_CONNECT;
    }
}
