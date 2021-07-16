package com.tvd12.ezyfoxerver.client.serializer;

import com.tvd12.ezyfoxserver.client.config.EzyClientConfig;
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
        Map reconnectMap = new HashMap<>();
        EzyReconnectConfig reconnectConfig = config.getReconnect();
        reconnectMap.put("maxReconnectCount", reconnectConfig.getMaxReconnectCount());
        reconnectMap.put("reconnectPeriod", reconnectConfig.getReconnectPeriod());
        reconnectMap.put("enable", reconnectConfig.isEnable());
        map.put("reconnect", reconnectMap);
        return map;
    }

}
