package com.tvd12.ezyfoxserver.client.serializer;

import com.tvd12.ezyfoxserver.client.constant.EzyDisconnectReasons;
import com.tvd12.ezyfoxserver.client.event.EzyConnectionFailureEvent;
import com.tvd12.ezyfoxserver.client.event.EzyDisconnectionEvent;
import com.tvd12.ezyfoxserver.client.event.EzyEvent;
import com.tvd12.ezyfoxserver.client.event.EzyEventType;
import com.tvd12.ezyfoxserver.client.event.EzyLostPingEvent;
import com.tvd12.ezyfoxserver.client.event.EzyTryConnectEvent;
import com.tvd12.ezyfoxserver.client.function.EzyFunction;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyEventSerializer {

    private final Map<EzyEventType, EzyFunction<EzyEvent, Map>> appliers;

    public EzyEventSerializer() {
        this.appliers = newAppliers();
    }

    public Map serialize(EzyEvent event) {
        EzyEventType eventType = event.getType();
        EzyFunction<EzyEvent, Map> func = getApplier(eventType);
        Map answer = func.apply(event);
        return answer;
    }

    private EzyFunction<EzyEvent, Map> getApplier(EzyEventType eventType) {
        if(appliers.containsKey(eventType))
            return appliers.get(eventType);
        throw new IllegalArgumentException("has no serializer for event type: " + eventType);
    }

    private Map<EzyEventType, EzyFunction<EzyEvent, Map>> newAppliers() {
        Map<EzyEventType, EzyFunction<EzyEvent, Map>> answer = new HashMap<>();
        answer.put(EzyEventType.CONNECTION_SUCCESS, new EzyFunction<EzyEvent, Map>() {
            @Override
            public Map apply(EzyEvent event) {
                return new HashMap<>();
            }
        });
        answer.put(EzyEventType.CONNECTION_FAILURE, new EzyFunction<EzyEvent, Map>() {
            @Override
            public Map apply(EzyEvent event) {
                EzyConnectionFailureEvent mevent = (EzyConnectionFailureEvent)event;
                Map map = new HashMap<>();
                map.put("reason", mevent.getReason().toString());
                return map;
            }
        });
        answer.put(EzyEventType.DISCONNECTION, new EzyFunction<EzyEvent, Map>() {
            @Override
            public Map apply(EzyEvent event) {
                EzyDisconnectionEvent mevent = (EzyDisconnectionEvent)event;
                Map map = new HashMap<>();
                int reason = mevent.getReason();
                String reasonName = EzyDisconnectReasons.getDisconnectReasonName(reason);
                map.put("reason", reasonName);
                return map;
            }
        });
        answer.put(EzyEventType.LOST_PING, new EzyFunction<EzyEvent, Map>() {
            @Override
            public Map apply(EzyEvent event) {
                EzyLostPingEvent mevent = (EzyLostPingEvent)event;
                Map map = new HashMap<>();
                map.put("count", mevent.getCount());
                return map;
            }
        });
        answer.put(EzyEventType.TRY_CONNECT, new EzyFunction<EzyEvent, Map>() {
            @Override
            public Map apply(EzyEvent event) {
                EzyTryConnectEvent mevent = (EzyTryConnectEvent)event;
                Map map = new HashMap<>();
                map.put("count", mevent.getCount());
                return map;
            }
        });
        return answer;
    }

}
