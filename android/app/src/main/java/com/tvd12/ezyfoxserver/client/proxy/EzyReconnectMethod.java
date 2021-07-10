package com.tvd12.ezyfoxserver.client.proxy;

import com.facebook.react.bridge.Map;
import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.EzyMethodNames;

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
