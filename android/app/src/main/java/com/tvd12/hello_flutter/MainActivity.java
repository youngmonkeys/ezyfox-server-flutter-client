package com.tvd12.hello_flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/battery";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel methodChannel = new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                CHANNEL
        );
        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getBatteryLevel")) {
                        int batteryLevel = getBatteryLevel();
                        result.success(batteryLevel);
                    }
                }
        );
    }

    private int getBatteryLevel() {
        return 100;
    }
}
