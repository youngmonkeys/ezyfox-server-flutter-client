package com.tvd12.ezyfoxserver.client.flutter.proxy;

import com.tvd12.ezyfoxserver.client.flutter.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.constant.EzyDisconnectReason;

import java.util.Map;

public class EzyDisconnectMethod extends EzyMethodProxy {

    @Override
    public Object invoke(Map params) {
        EzyClient client = getClient(params);
        int reason = EzyDisconnectReason.CLOSE.getId();
        if(params.containsKey("reason"))
            reason = (int) params.get("reason");
        client.disconnect(reason);
        return Boolean.TRUE;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_DISCONNECT;
    }
}
