import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nm405_enigmatic_cipherers/screens/location_switcher.dart';
import 'package:sensors/sensors.dart';

import 'ins_demo.dart';

class PdrProvider {
  final LatLng initLocation;
  int angleFromNorth;
  final int eRadius = 6371000;
  Location mCurrentLocation;
  double MagnitudePrevious = 0.0;
  var bearing;
  final eventChannel = EventChannel("compass");
  final ValueChanged<Location> onNewLocation;

  PdrProvider(this.initLocation, this.onNewLocation);

  void startLocationStream() {
    accelerometerEvents.listen((event) {
      double Magnitude = Math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      double MagnitudeDelta = Magnitude - MagnitudePrevious;
      MagnitudePrevious = Magnitude;

      if (MagnitudeDelta > 2) {
        if (bearing != null) {
          computeNextStep(0.75, bearing);
          onNewLocation(mCurrentLocation);
        }
      }
    });

    eventChannel.receiveBroadcastStream().listen((event) {
      bearing = event;
    });
  }

  Location computeNextStep(double stepSize, double bearing) {
    Location newLoc = new Location(mCurrentLocation);
    double angDistance = stepSize / eRadius;
    double oldLat = mCurrentLocation.getLatitude();
    double oldLng = mCurrentLocation.getLongitude();
    double newLat = Math.asin(Math.sin(toRadians(oldLat)) * Math.cos(angDistance) +
        Math.cos(toRadians(oldLat)) * Math.sin(angDistance) * Math.cos(bearing));
    double newLon = toRadians(oldLng) +
        Math.atan2(Math.sin(bearing) * Math.sin(angDistance) * Math.cos(toRadians(oldLat)),
            Math.cos(angDistance) - Math.sin(toRadians(oldLat)) * Math.sin(newLat));
    newLoc.setLatitude(toDegrees(newLat));
    newLoc.setLongitude(toDegrees(newLon));

    newLoc.setBearing((mCurrentLocation.getBearing() + 180) % 360);
    mCurrentLocation = newLoc;

    return newLoc;
  }
}
