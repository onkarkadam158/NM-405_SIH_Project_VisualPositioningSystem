import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as Math;
import 'package:location/location.dart' as location;

class InsDemo extends StatefulWidget {
  @override
  _InsDemoState createState() => _InsDemoState();
}

class _InsDemoState extends State<InsDemo> {
  int angleFromNorth;
  final int eRadius = 6371000;
  Location mCurrentLocation;
  double MagnitudePrevious = 0.0;

  int stepCount = 0;
  var bearing;

  final eventChannel = EventChannel("compass");

  List<Location> locations = [];

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((event) {
      double Magnitude = Math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      double MagnitudeDelta = Magnitude - MagnitudePrevious;
      MagnitudePrevious = Magnitude;

      if (MagnitudeDelta > 2) {
        stepCount++;
        print(stepCount);
        if(bearing != null) {
          setState(() {
            computeNextStep(0.75, bearing);
          });
        }
      }
    });

    eventChannel.receiveBroadcastStream().listen((event) {
      bearing = event;
    });

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("INS Demo"),
      ),
      body: mCurrentLocation == null ?  Container() : ListView.builder(itemBuilder: (context, position) {
        return ListTile(
          title: Text(locations[position].toString()),
        );
      }, itemCount: locations.length,),
    );
  }

  init() async {
    var loc = await location.Location.instance.getLocation();
    mCurrentLocation = Location.empty();
    mCurrentLocation.longitude = loc.longitude;
    mCurrentLocation.latitude = loc.latitude;
    mCurrentLocation.bearing = 0.0;
    locations.add(Location.empty()..latitude=loc.latitude..longitude=loc.longitude..bearing=0.0);
  }

  Location computeNextStep(double stepSize, double bearing) {
    Location newLoc = new Location(mCurrentLocation);
    double angDistance = stepSize / eRadius;
    double oldLat = mCurrentLocation.getLatitude();
    double oldLng = mCurrentLocation.getLongitude();
    double newLat = Math.asin(Math.sin(toRadians(oldLat))* Math.cos(angDistance) +
        Math.cos(toRadians(oldLat)) * Math.sin(angDistance)* Math.cos(bearing));
    double newLon = toRadians(oldLng) +
        Math.atan2(Math.sin(bearing) * Math.sin(angDistance)* Math.cos(toRadians(oldLat)),
            Math.cos(angDistance) - Math.sin(toRadians(oldLat))* Math.sin(newLat));
    newLoc.setLatitude(toDegrees(newLat));
    newLoc.setLongitude(toDegrees(newLon));

    newLoc.setBearing((mCurrentLocation.getBearing()+180)% 360);
    locations.add(Location.empty()..latitude=newLoc.latitude..longitude=newLoc.longitude..bearing=newLoc.bearing);
    mCurrentLocation = newLoc;

    return newLoc;
  }
}

class Location {
  double latitude;
  double longitude;
  double bearing;

  Location.empty() {}

  Location(Location location) {
    this.latitude = location.latitude;
    this.longitude = location.longitude;
    this.bearing = location.bearing;
  }

  getLatitude() => latitude;
  getLongitude() => longitude;
  getBearing() => bearing;

  setLatitude(val) => latitude = val;
  setLongitude(val) => longitude = val;
  setBearing(val) => bearing = val;

  @override
  String toString() {
    return "LAT: $latitude LONG: $longitude";
  }
}

double toRadians(val) {
  return val / 57.2958;
}

double toDegrees(val) {
  return val * 57.2958;
}