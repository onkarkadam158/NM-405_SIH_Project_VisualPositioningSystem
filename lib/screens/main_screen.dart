import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("LocatAR"),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: Image.asset('images/logo.jpeg')),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              color: Colors.redAccent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Icon(Icons.keyboard_voice, color: Colors.white, size: 50.0,),
                  Text("Speak Action", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                Container(
                  child: Center(
                      child: Text(
                    "Map Route",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                  color: Colors.red,
                ),
                Container(
                  child: Center(
                      child: Text(
                        "View Routes",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  color: Colors.purple,
                ),
                Container(
                  child: Center(
                      child: Text(
                        "Navigate (Indoor)",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  color: Colors.green,
                ),
                Container(
                  child: Center(
                      child: Text(
                        "Navigate (Indoor + Outdoor)",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  color: Colors.pink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
