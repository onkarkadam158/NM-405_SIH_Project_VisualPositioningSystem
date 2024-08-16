import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routes"),
      ),
      body: Column(
        children: [
          Expanded(child: GestureDetector(
            onTap: () {
              FlutterTts().speak("Choose best route");
              Fluttertoast.showToast(msg: "Audio playing");
            },
            onDoubleTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              color: Colors.blue,
              child: Center(
                child: Text("Choose best route", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),
          )),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text("New Route"),
                      subtitle: Text("Created ${DateTime.now().day} / ${DateTime.now().month.toString()}"),
                    ),
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
