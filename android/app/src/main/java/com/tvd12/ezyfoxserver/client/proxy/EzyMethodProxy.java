package com.tvd12.ezyfoxserver.client.proxy;

import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.EzyClients;

import java.util.Map;

/**
 * Created by tavandung12 on 10/24/18.
 */

public abstract class EzyMethodProxy {

    protected EzyClients clients = EzyClients.getInstance();

    public abstract Object invoke(Map params);
    public abstract String getName();

    public void validate(Map params) {}

    protected EzyClient getClient(String name) {
        EzyClient client = clients.getClient(name);
        return client;
    }

    protected EzyClient getClient(Map params) {
        if(!params.containsKey("clientName"))
            throw new IllegalArgumentException("must specific client name");
        String clientName = (String)params.get("clientName");
        EzyClient client = getClient(clientName);
        return client;
    }
}
