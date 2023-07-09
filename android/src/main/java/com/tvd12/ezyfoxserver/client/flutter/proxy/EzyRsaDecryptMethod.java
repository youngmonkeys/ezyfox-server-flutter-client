package com.tvd12.ezyfoxserver.client.flutter.proxy;

import com.tvd12.ezyfoxserver.client.flutter.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.security.EzyAsyCrypt;

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
