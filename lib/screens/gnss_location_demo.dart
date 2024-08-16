import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GnssLocationDemo extends StatefulWidget {
  @override
  _GnssLocationDemoState createState() => _GnssLocationDemoState();
}

class _GnssLocationDemoState extends State<GnssLocationDemo> {
  final eventChannel = EventChannel("location");

  String val;

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen((event) {
      print(event);
      setState(() {
        val = event.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GnssLocationDemo"),
      ),
      body: Center(
        child: Text(val ?? ""),
      ),
    );
  }
}
