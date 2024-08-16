package dev.joshi.nm405_enigmatic_cipherers;

import android.content.Context;

import io.flutter.plugin.common.EventChannel;

public class LocationStreamHandler implements EventChannel.StreamHandler {

    GnssContainer gnssContainer;
    Context context;
    RealTimePositionVelocityCalculator pvtCalc;

    public LocationStreamHandler(Context context) {
        this.context = context;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        pvtCalc =  new RealTimePositionVelocityCalculator(events);
        gnssContainer = new GnssContainer(context, pvtCalc);
        gnssContainer.registerAll();
    }

    @Override
    public void onCancel(Object arguments) {
        gnssContainer.unregisterAll();
    }

}
