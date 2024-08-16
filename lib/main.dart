import 'package:flutter/material.dart';
import 'package:nm405_enigmatic_cipherers/screens/bluetooth_screen.dart';
import 'package:nm405_enigmatic_cipherers/screens/braille_demo.dart';
import 'package:nm405_enigmatic_cipherers/screens/compass_demo.dart';
import 'package:nm405_enigmatic_cipherers/screens/gnss_location_demo.dart';
import 'package:nm405_enigmatic_cipherers/screens/home_screen.dart';
import 'package:nm405_enigmatic_cipherers/screens/ins_demo.dart';
import 'package:nm405_enigmatic_cipherers/screens/main_screen.dart';
import 'package:nm405_enigmatic_cipherers/screens/vps_mapping_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

