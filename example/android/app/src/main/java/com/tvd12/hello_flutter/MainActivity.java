package com.tvd12.hello_flutter;

import androidx.annotation.NonNull;

import com.tvd12.ezyfoxserver.client.EzyClientProxy;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        EzyClientProxy.getInstance().register(
                flutterEngine.getDartExecutor().getBinaryMessenger()
        );
    }
}
