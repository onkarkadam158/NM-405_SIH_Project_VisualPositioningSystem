import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:location/location.dart';
import 'package:nm405_enigmatic_cipherers/screens/bluetooth_screen.dart';
import 'package:nm405_enigmatic_cipherers/screens/fall_screen.dart';
import 'package:sensors/sensors.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math' as Math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ArCoreController controller;
  Location location = new Location();

  List<Offset> locations = [];

  Offset mostRecentLocation;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Uint8List markerImageBytes;
  Uint8List rightImageBytes;

  double initBearing;
  bool bearingInit = false;

  final eventChannel = EventChannel("compass");

  double currentBearing;

  bool hasFallen = false;

  bool showVibrationMessage = false;

  Timer _timer;
  int _start = 10;

  bool firstDone = false;

  Timer timer;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
    location.onLocationChanged.listen((event) {
      mostRecentLocation = Offset(event.latitude, event.longitude);
    });
    eventChannel.receiveBroadcastStream().listen((event) {
      if (bearingInit) {
        initBearing = event;
        bearingInit = false;
      }

      currentBearing = event;

      if (initBearing != null) {
        if ((currentBearing < initBearing + 10) && (currentBearing > initBearing - 10)) {
          setState(() {
            showVibrationMessage = true;
          });
        } else {
          setState(() {
            showVibrationMessage = false;
          });
        }
      }
    });
    accelerometerEvents.listen((event) {
      var rootSquare = Math.sqrt(Math.pow(event.x, 2) + Math.pow(event.y, 2) + Math.pow(event.z, 2));

      if (rootSquare < 2.0) {
        setState(() {
          hasFallen = true;
        });
      }
    });

    init();
  }

  bool deviceDisconnected = false;

  SpeechToText speech = SpeechToText();

  void init() async {
//    var blue = FlutterBlue.instance;
//
//    timer = Timer.periodic(Duration(seconds: 8), (timer) {
//      blue.connectedDevices.then((value) {
//        if (value.length == 0) {
//          timer.cancel();
//          setState(() {
//            deviceDisconnected = true;
//          });
//        }
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
//    if (deviceDisconnected)
//      return Scaffold(
//        appBar: AppBar(
//          title: Text("Bluetooth"),
//        ),
//        body: _showDisconnectedScreen(),
//      );

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text("Fall Demo"),
              leading: Icon(Icons.phone_android),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FallScreen()));
              },
            ),
            ListTile(
              title: Text("Bluetooth Demo"),
              leading: Icon(Icons.bluetooth),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothScreen()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("VPS"),
      ),
      body: hasFallen
          ? _buildFallScreen()
          : Stack(
              children: [
                FutureBuilder<PermissionStatus>(
                    future: location.hasPermission(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data == PermissionStatus.denied) {
                        return Center(child: Text("Permission not granted!"));
                      }

                      return GestureDetector(
                        onDoubleTap: () async {
                          if (!firstDone) {
                            _startDemo();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Navigation has now started")));
                            bearingInit = true;
                            firstDone = true;
                          } else {
                            print(initBearing);
                            initBearing = 0;
                            _startDemo2();
                          }
                        },
                        onLongPressUp: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Alert: LONG PRESS UP"),
                                    content: Text("Calling Police in 5 seconds"),
                                  ));
                          Future.delayed(Duration(seconds: 5)).then((value) {
                            _launchCaller();
                          });
                        },
                        onScaleEnd: (scale) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Alert: SCALE"),
                                    content: Text("Calling Emergency Contact in 5 seconds"),
                                  ));
                          Future.delayed(Duration(seconds: 5)).then((value) {
                            _launchCaller();
                          });
                        },
                        child: ArCoreView(
                          onArCoreViewCreated: (controller) {
                            this.controller = controller;
                          },
                        ),
                      );
                    }),
                if (showVibrationMessage)
                  Positioned(
                    bottom: 40.0,
                    left: 160.0,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "VIBRATE!",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildFallScreen() {
    startTimer();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "YOU HAVE FALLEN!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Text("Press Cancel in case this was accidentally triggered"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$_start",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(onPressed: () {}, child: Text("CANCEL")),
          ),
        ],
      ),
    );
  }

  void _startDemo() {
    _addStartCube(controller);
    for (int y = 0; y < 10; y++) {
      _addIntermediateCubes(y);
    }
    _addEndCube(controller);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text("You double tapped. Added new location pin: $mostRecentLocation")));
  }

  void _startDemo2() {
    for (int y = 0; y < 10; y++) {
      _addIntermediateCubes2(y);
    }
    final material2 = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
      textureBytes: markerImageBytes,
    );
    final cube2 = ArCoreCube(
      materials: [material2],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node2 = ArCoreNode(
      shape: cube2,
      position: vector.Vector3(20, 0, -10),
    );

    controller.addArCoreNode(node2);
  }

  void _addStartCube(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
      textureBytes: markerImageBytes,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(0, 0, 0),
    );
    controller.addArCoreNode(node);
  }

  void _addIntermediateCubes(int y) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.2, 0.2, 0.2),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(0, 0, -y.toDouble()),
    );
    controller.addArCoreNode(node);
  }

  void _addIntermediateCubes2(int y) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.2, 0.2, 0.2),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(y.toDouble() * 2, 0, -10),
    );
    controller.addArCoreNode(node);
  }

  void _addEndCube(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
      textureBytes: rightImageBytes,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.5, 0.5, 0.5),
    );
    final node = ArCoreNode(
      shape: cube,
      position: vector.Vector3(0, 0, -10.0),
    );
    controller.addArCoreNode(node);
  }

  void _initLocation() async {
    markerImageBytes = (await rootBundle.load('images/marker.png')).buffer.asUint8List();
    rightImageBytes = (await rootBundle.load('images/right_turn.png')).buffer.asUint8List();

    PermissionStatus _permissionGranted;

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    setState(() {});
  }

  _launchCaller() async {
//    const url = "tel:9552526995";
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
  }

  Widget _showDisconnectedScreen() {
    initVoice();
    FlutterTts().speak("Your device has disconnected. \nPlease speak the password, \nor else authorities will be informed.");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your device has disconnected. \n\nPlease speak the password,\nor else authorities will be informed.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SpinKitRotatingCircle(
            color: Colors.blue,
            size: 50.0,
          ),
        ],
      ),
    );
  }

  void initVoice() async {
    Future.delayed(Duration(seconds: 8)).then((value) {
      setState(() {
        deviceDisconnected = false;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Alert"),
                content: Text("Correct password. No one was informed."),
              ));
    });

//    bool available = await speech.initialize( onStatus: (stat){}, onError:  (err){} );
//    if ( available ) {
//      speech.listen( onResult: (res) {
//        print(res.recognizedWords);
//        if (res.recognizedWords.contains("password")) {
//          showDialog(context: context, builder: (context) => AlertDialog(
//            title: Text("Alert"),
//            content: Text("Correct password. No one was informed."),
//          ));
//        } else {
//
//        }
//      }, listenFor: Duration(seconds: 5));
//    }
//    else {
//      print("The user has denied the use of speech recognition.");
//    }
  }
}
