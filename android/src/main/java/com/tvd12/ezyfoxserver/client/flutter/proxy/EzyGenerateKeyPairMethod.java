package com.tvd12.ezyfoxserver.client.flutter.proxy;

import android.util.Base64;

import com.tvd12.ezyfoxserver.client.flutter.EzyMethodNames;
import com.tvd12.ezyfoxserver.client.security.EzyKeysGenerator;

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
        Map<String, Object> answer = new HashMap<>();
        answer.put("publicKey", Base64.encodeToString(publicKey, Base64.NO_WRAP));
        answer.put("privateKey", privateKey);
        return answer;
    }

    @Override
    public String getName() {
        return EzyMethodNames.METHOD_GENERATE_KEY_PAIR;
    }
}
