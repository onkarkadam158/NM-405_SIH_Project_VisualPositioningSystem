import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nm405_enigmatic_cipherers/screens/pdr_provider.dart';
import 'package:raw_gnss/raw_gnss.dart';

class LocationSwitcher {

  final gnssProvider = EventChannel("location");
  PdrProvider pdrProvider;

  bool gnssEnabled;
  bool pdrEnabled;

  LatLng currentLocation;

  LocationSwitcher() {
    initPdr();
    initGnss();
  }

  void start() {
    RawGnss().gnssMeasurementEvents.listen((event) {
      if(event.measurements.length < 4) {
        pdrEnabled = true;
        gnssEnabled = false;
      } else {
        pdrEnabled = false;
        gnssEnabled = true;
      }
    });
  }

  void initPdr() async {
    var initLoc = await Location().getLocation();
    pdrProvider = PdrProvider(LatLng(latitude: initLoc.latitude, longitude: initLoc.longitude), (val) {
      if(pdrEnabled) {
        currentLocation = LatLng(latitude: val.latitude, longitude: val.longitude);
      }
    });
  }

  void initGnss() {
    gnssProvider.receiveBroadcastStream().listen((event) {
      if(gnssEnabled) {
        currentLocation = LatLng(latitude: event["lat"], longitude: event["long"]);
      }
    });
  }

}

class LatLng {
  double latitude;
  double longitude;

  LatLng({this.latitude, this.longitude});

  @override
  String toString() {
    return "LAT: $latitude LONG: $longitude";
  }
}
