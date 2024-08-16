package dev.joshi.nm405_enigmatic_cipherers;

import android.content.Context;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    EventChannel locationChannel;
    LocationStreamHandler streamHandler;

    EventChannel compassChannel;
    CompassStreamHandler compassStreamHandler;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());

        streamHandler = new LocationStreamHandler(this);

        compassStreamHandler = new CompassStreamHandler((SensorManager) getSystemService(Context.SENSOR_SERVICE));

        // Method controller code from earlier hidden here for clarity

        locationChannel = new EventChannel(getFlutterEngine().getDartExecutor(), "location");

        locationChannel.setStreamHandler(streamHandler);

        compassChannel = new EventChannel(getFlutterEngine().getDartExecutor(), "compass");

        compassChannel.setStreamHandler(compassStreamHandler);
    }
}
