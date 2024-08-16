package dev.joshi.nm405_enigmatic_cipherers;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.EventChannel;

public class CompassStreamHandler implements EventChannel.StreamHandler {

    private float[] gravityData = new float[3];
    private float[] geomagneticData  = new float[3];
    private boolean hasGravityData = false;
    private boolean hasGeomagneticData = false;
    private double rotationInDegrees;

    private SensorManager sensorManager;
    private Sensor mSensor1;
    private Sensor mSensor2;

    SensorEventListener listener;

    CompassStreamHandler(SensorManager sensorManager) {
        this.sensorManager = sensorManager;
        mSensor1 = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        mSensor2 = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        listener = new SensorEventListener() {
            @Override
            public void onSensorChanged(SensorEvent sensorEvent) {
                switch (sensorEvent.sensor.getType()){
                    case Sensor.TYPE_ACCELEROMETER:
                        System.arraycopy(sensorEvent.values, 0, gravityData, 0, 3);
                        hasGravityData = true;
                        break;
                    case Sensor.TYPE_MAGNETIC_FIELD:
                        System.arraycopy(sensorEvent.values, 0, geomagneticData, 0, 3);
                        hasGeomagneticData = true;
                        break;
                    default:
                        return;
                }

                if (hasGravityData && hasGeomagneticData) {
                    float identityMatrix[] = new float[9];
                    float rotationMatrix[] = new float[9];
                    boolean success = SensorManager.getRotationMatrix(rotationMatrix, identityMatrix,
                            gravityData, geomagneticData);

                    if (success) {
                        float orientationMatrix[] = new float[3];
                        SensorManager.getOrientation(rotationMatrix, orientationMatrix);
                        float rotationInRadians = orientationMatrix[0];
                        rotationInDegrees = Math.toDegrees(rotationInRadians);

                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                events.success(rotationInDegrees);
                            }
                        });
                    }
                }
            }

            @Override
            public void onAccuracyChanged(Sensor sensor, int i) {

            }
        };

        sensorManager.registerListener(listener, mSensor1, SensorManager.SENSOR_DELAY_FASTEST);
        sensorManager.registerListener(listener, mSensor2, SensorManager.SENSOR_DELAY_FASTEST);
    }

    @Override
    public void onCancel(Object arguments) {
        sensorManager.unregisterListener(listener);
    }
}
