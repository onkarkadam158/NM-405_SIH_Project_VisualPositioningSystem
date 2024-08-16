import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:math' as Math;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  var blue = FlutterBlue.instance;

  String deviceName = "LE_WH-XB900N";

  Map<String, double> map = {};

  Timer timer;

  bool deviceDisconnected = false;

  stt.SpeechToText speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth"),
      ),
      body: deviceDisconnected ? _showDisconnectedScreen() : ListView.builder(
        itemBuilder: (context, position) {
          return ListTile(
            title: Text(map.keys.toList()[position]),
            subtitle: Text(map.values.toList()[position].toString()),
          );
        },
        itemCount: map.length,
      ),
    );
  }

  Widget _showDisconnectedScreen() {
    initVoice();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Your device has disconnected. Please speak the password, or else authorities will be informed."),
      ),
    );
  }

  void init() async {
    blue.scan(timeout: Duration(milliseconds: 60000), allowDuplicates: true).listen((event) {
      if (event.device.name != "")
        setState(() {
          map[event.device.name] = getDistance(event.rssi, -60);
        });
    });

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      blue.connectedDevices.then((value) {
        if (value.length == 0) {
          timer.cancel();
          setState(() {
            deviceDisconnected = true;
          });
        }
      });
    });
  }

  double getDistance(int rssi, int txPower) {
    return Math.pow(10, (txPower - rssi) / (10 * 2));
  }

  void initVoice() async {
    bool available = await speech.initialize( onStatus: (stat){}, onError:  (err){} );
    if ( available ) {
      speech.listen( onResult: (res) {
        print(res.recognizedWords);
        if (res.recognizedWords.contains("password")) {
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("Alert"),
            content: Text("Correct password. No one was informed."),
          ));
        } else {

        }
      }, listenFor: Duration(seconds: 5));
    }
    else {
      print("The user has denied the use of speech recognition.");
    }
  }
}
