package com.tvd12.ezyfoxerver.client.proxy;

import com.tvd12.ezyfoxerver.client.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.EzyClient;
import com.tvd12.ezyfoxserver.client.constant.EzyConnectionStatus;
import com.tvd12.ezyfoxserver.client.sercurity.EzyKeysGenerator;

import java.security.KeyPair;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by tavandung12 on 10/25/18.
 */

public class EzyGenerateKeyPairMethod extends EzyMethodProxy {
    @Override
    public Object invoke(Map params) {
        KeyPair keyPair = EzyKeysGenerator.builder()
                .build()
                .generate();
        byte[] publicKey = keyPair.getPublic().getEncoded();
        byte[] privateKey = keyPair.getPrivate().getEncoded();
        Map<String, byte[]> answer = new HashMap<>();
        answer.put("publicKey", publicKey);
        answer.put("privateKey", privateKey);
        return answer;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_GENERATE_KEY_PAIR;
    }
}
