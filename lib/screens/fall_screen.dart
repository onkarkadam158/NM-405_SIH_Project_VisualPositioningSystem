import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as Math;

class FallScreen extends StatefulWidget {
  @override
  _FallScreenState createState() => _FallScreenState();
}

class _FallScreenState extends State<FallScreen> {

  bool hasFallen = false;

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((event) {
      var rootSquare= Math.sqrt(Math.pow(event.x, 2) + Math.pow(event.y, 2) + Math.pow(event.z, 2));

      if(rootSquare < 2.0) {
        setState(() {
          hasFallen = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fall Demo"),
      ),
      body: Center(child: Text(hasFallen ? "REPORTING FALL TO SERVER" : "Everything is normal", style: TextStyle(
        color: hasFallen ? Colors.red : Colors.green,
        fontWeight: FontWeight.bold
      ),)),
    );
  }
}
