package com.tvd12.ezyfoxerver.client.proxy;

import com.tvd12.ezyfoxerver.client.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.sercurity.EzyAsyCrypt;
import com.tvd12.ezyfoxserver.client.sercurity.EzyKeysGenerator;

import java.security.KeyPair;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyRsaDecryptMethod extends EzyMethodProxy {
    @Override
    public Object invoke(Map params) throws Exception {
        byte[] message = (byte[])params.get("message");
        byte[] privateKey = (byte[])params.get("privateKey");
        return EzyAsyCrypt.builder()
                .privateKey(privateKey)
                .build()
                .decrypt(message);
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_RSA_DECRYPT;
    }
}
