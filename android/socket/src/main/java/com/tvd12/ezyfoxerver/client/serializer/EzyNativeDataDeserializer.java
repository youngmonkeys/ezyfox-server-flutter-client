package com.tvd12.ezyfoxerver.client.serializer;

import com.tvd12.ezyfoxserver.client.entity.EzyArray;
import com.tvd12.ezyfoxserver.client.entity.EzyObject;
import com.tvd12.ezyfoxserver.client.factory.EzyEntityFactory;

import java.util.List;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyNativeDataDeserializer {

    public EzyArray fromList(List value) {
        EzyArray answer = EzyEntityFactory.newArray();
        answer.add(value);
        return answer;
    }

    public EzyObject fromMap(Map value) {
       EzyObject answer = EzyEntityFactory.newObject();
       answer.putAll(value);
       return answer;
    }
}
