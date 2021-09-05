package com.tvd12.ezyfoxserver.client.flutter.serializer;

import com.tvd12.ezyfoxserver.client.config.EzyClientConfig;
import com.tvd12.ezyfoxserver.client.config.EzyPingConfig;
import com.tvd12.ezyfoxserver.client.config.EzyReconnectConfig;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyClientConfigSerializer {

    public Map serialize(EzyClientConfig config) {
        Map map = new HashMap<>();
        map.put("clientName", config.getClientName());
        map.put("zoneName", config.getZoneName());

        EzyPingConfig pingConfig = config.getPing();
        Map pingMap = new HashMap<>();
        pingMap.put("maxLostPingCount", pingConfig.getMaxLostPingCount());
        pingMap.put("pingPeriod", pingConfig.getPingPeriod());
        map.put("ping", pingMap);


        EzyReconnectConfig reconnectConfig = config.getReconnect();
        Map reconnectMap = new HashMap<>();
        reconnectMap.put("maxReconnectCount", reconnectConfig.getMaxReconnectCount());
        reconnectMap.put("reconnectPeriod", reconnectConfig.getReconnectPeriod());
        reconnectMap.put("enable", reconnectConfig.isEnable());
        map.put("reconnect", reconnectMap);
        return map;
    }

}
