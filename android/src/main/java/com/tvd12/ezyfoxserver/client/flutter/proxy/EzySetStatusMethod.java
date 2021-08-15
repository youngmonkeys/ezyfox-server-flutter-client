package com.tvd12.ezyfoxserver.client.flutter.proxy;

import com.tvd12.ezyfoxserver.client.flutter.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.constant.EzyConnectionStatus;

import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzySetStatusMethod extends EzyMethodProxy {
    @Override
    public Object invoke(Map params) {
        EzyClient client = getClient(params);
        String statusName = (String) params.get("status");
        client.setStatus(EzyConnectionStatus.valueOf(statusName));
        return Boolean.TRUE;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_SET_STATUS;
    }
}
