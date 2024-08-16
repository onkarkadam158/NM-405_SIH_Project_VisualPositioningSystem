import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompassDemo extends StatefulWidget {
  @override
  _CompassDemoState createState() => _CompassDemoState();
}

class _CompassDemoState extends State<CompassDemo> {
  final eventChannel = EventChannel("compass");

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
        title: Text("Compass Demo"),
      ),
      body: Center(
        child: Text(val ?? ""),
      ),
    );
  }
}
