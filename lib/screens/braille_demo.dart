import 'package:flutter/material.dart';

class BrailleDemo extends StatefulWidget {
  @override
  _BrailleDemoState createState() => _BrailleDemoState();
}

class _BrailleDemoState extends State<BrailleDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Braille Demo"),
      ),
      body: Center(
        child: Tooltip(
          message: "Enter Route Name",
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Route Name"
              ),
            ),
          ),
        ),
      ),
    );
  }
}
