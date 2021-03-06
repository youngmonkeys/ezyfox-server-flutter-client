package com.tvd12.ezyfoxserver.client.flutter.proxy;

import com.tvd12.ezyfoxserver.client.flutter.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.EzyClient;

import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyReconnectMethod extends EzyMethodProxy {
    @Override
    public Object invoke(Map params) {
        EzyClient client = getClient(params);
        boolean answer = client.reconnect();
        return answer;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_RECONNECT;
    }
}
