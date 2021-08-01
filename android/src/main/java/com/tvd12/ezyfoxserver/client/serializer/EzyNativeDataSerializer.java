package com.tvd12.ezyfoxserver.client.serializer;

import com.tvd12.ezyfoxserver.client.entity.EzyArray;
import com.tvd12.ezyfoxserver.client.entity.EzyObject;

import java.util.List;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyNativeDataSerializer {

    public List toList(EzyArray value) {
        if(value == null)
            return null;
        return value.toList();
    }

    public Map toMap(EzyObject value) {
        if(value == null)
            return null;
        return value.toMap();
    }

}
