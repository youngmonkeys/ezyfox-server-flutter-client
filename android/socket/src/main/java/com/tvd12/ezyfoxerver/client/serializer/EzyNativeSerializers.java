package com.tvd12.ezyfoxerver.client.serializer;

import com.tvd12.ezyfoxserver.client.config.EzyClientConfig;
import com.tvd12.ezyfoxserver.client.entity.EzyArray;
import com.tvd12.ezyfoxserver.client.event.EzyEvent;

import java.util.List;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public final class EzyNativeSerializers {

    private static final EzyEventSerializer EVENT_SERIALIZER = new EzyEventSerializer();
    private static final EzyNativeDataSerializer DATA_SERIALIZER = new EzyNativeDataSerializer();
    private static final EzyNativeDataDeserializer DATA_DESERIALIZER = new EzyNativeDataDeserializer();
    private static final EzyClientConfigSerializer CLIENT_CONFIG_SERIALIZER = new EzyClientConfigSerializer();

    private EzyNativeSerializers() { }

    public static Map serialize(EzyEvent event) {
        Map answer = EVENT_SERIALIZER.serialize(event);
        return answer;
    }

    public static List toList(EzyArray array) {
        List answer = DATA_SERIALIZER.toList(array);
        return answer;
    }

    public static EzyArray fromList(List array) {
        EzyArray answer = DATA_DESERIALIZER.fromList(array);
        return answer;
    }

    public static Map serialize(EzyClientConfig config) {
        Map answer = CLIENT_CONFIG_SERIALIZER.serialize(config);
        return answer;
    }

}
