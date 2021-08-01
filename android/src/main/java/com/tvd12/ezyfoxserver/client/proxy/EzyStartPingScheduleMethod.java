package com.tvd12.ezyfoxserver.client.proxy;

import com.tvd12.ezyfoxserver.client.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.socket.EzyPingSchedule;

import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyStartPingScheduleMethod extends EzyMethodProxy {
    @Override
    public Object invoke(Map params) {
        EzyClient client = getClient(params);
        EzyPingSchedule pingSchedule = client.getPingSchedule();
        pingSchedule.start();
        return Boolean.TRUE;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_START_PING_SCHEDULE;
    }
}
