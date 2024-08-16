import 'dart:typed_data';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:nm405_enigmatic_cipherers/screens/routes_screen.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class VpsMappingDemo extends StatefulWidget {
  @override
  _VpsMappingDemoState createState() => _VpsMappingDemoState();
}

class _VpsMappingDemoState extends State<VpsMappingDemo> {
  ArCoreController controller;
  Location location = new Location();

  List<PointData> points = [];

  bool anchorExists = false;

  AnchorData anchorData;

  bool end = false;

  bool stairStart = false;
  bool stairEnd = false;

  bool returned = false;
  Uint8List markerImageBytes;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    markerImageBytes = (await rootBundle.load('images/marker.png')).buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(returned ? "VPS" : "VPS Mapping"),
        ),
        body: !end
            ? (anchorExists
                ? Stack(
                    children: [
                      ArCoreView(
                        onArCoreViewCreated: (controller) {
                          this.controller = controller;
                          controller.onPlaneTap = _handleOnPlaneTap;
                        },
                        enableTapRecognizer: true,
                      ),
//              if(stairStart)
//              Positioned(
//                bottom: 160.0,
//                left: 160.0,
//                child: Container(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Text("Stair START", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),
//                  ),
//                  color: Colors.blue,
//                )
//              ),
//              if(stairEnd)
//                Positioned(
//                    bottom: 100.0,
//                    left: 160.0,
//                    child: Container(
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text("Stair END", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),
//                      ),
//                      color: Colors.blue,
//                    )
//                ),
                      Positioned(
                        bottom: 40.0,
                        left: 160.0,
                        child: FlatButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "END",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => RoutesScreen()));
                            setState(() {
                              returned = true;
                            });

                            for(int i = 0; i < points.length; i++) {
                              var point = points[i];

                              final markerMaterial = ArCoreMaterial(
                                color: Color.fromARGB(120, 66, 134, 244),
                                metallic: 1.0,
                                textureBytes: markerImageBytes,
                              );

                              final markerShape = ArCoreCube(
                                materials: [markerMaterial],
                                size: vector.Vector3(0.2, 0.2, 0.2),
                              );

                              final earth = ArCoreNode(
                                  shape: markerShape, position: point.translation + vector.Vector3(0.0, 1.0, 0.0), rotation: point.rotation);

                              controller.addArCoreNodeWithAnchor(earth);

                              if(i < points.length - 1) {
                                var nextPoint = points[i+1];

                                var transInt1 = (nextPoint.translation - point.translation) / 3;
                                var rotInt1 = (nextPoint.rotation - point.rotation) / 3;

                                var transInt2= (nextPoint.translation - point.translation) / 3;
                                var rotInt2 = (nextPoint.rotation - point.rotation) / 3;

                                transInt2.scale(2);
                                rotInt2.scale(2);

                                final markerMaterial = ArCoreMaterial(
                                  color: Color.fromARGB(120, 66, 134, 244),
                                  metallic: 1.0,
                                );

                                final markerShape = ArCoreCube(
                                  materials: [markerMaterial],
                                  size: vector.Vector3(0.1, 0.1, 0.1),
                                );

                                final intPoint1 = ArCoreNode(
                                    shape: markerShape, position: point.translation + transInt1 + vector.Vector3(0.0, 1.0, 0.0), rotation: point.rotation + rotInt1);

                                final intPoint2 = ArCoreNode(
                                    shape: markerShape, position: point.translation + transInt2 + vector.Vector3(0.0, 1.0, 0.0), rotation: point.rotation + rotInt2);

                                controller.addArCoreNodeWithAnchor(intPoint1);
                                controller.addArCoreNodeWithAnchor(intPoint2);
                              }

                            }
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: RaisedButton(
                      onPressed: () async {
                        var loc = await location.getLocation();

                        anchorData = AnchorData(loc.latitude, loc.latitude, loc.altitude);

                        setState(() {
                          anchorExists = true;
                        });
                      },
                      child: Text("Anchor Point"),
                    ),
                  ))
            : Column(
                children: [
                  ListTile(
                    title: Text("Anchor"),
                    subtitle: Text(anchorData.toString()),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, position) {
                        return ListTile(
                          title: Text("Point ${position + 1}."),
                          subtitle: Text(points[position].toString()),
                        );
                      },
                      itemCount: points.length,
                    ),
                  ),
                ],
              ));
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;

    print(hit.pose.translation);
    print(hit.pose.rotation);

    final earthMaterial = ArCoreMaterial(color: Color.fromARGB(120, 66, 134, 244));

    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.05,
    );

    final earth = ArCoreNode(
        shape: earthShape, position: hit.pose.translation + vector.Vector3(0.0, 0.0, 0.0), rotation: hit.pose.rotation);

    controller.addArCoreNodeWithAnchor(earth);

    if (points.isNotEmpty) {
      if (!stairStart) {
        if ((hit.pose.translation.y - points.last.translation.y).abs() > 0.1) {
          setState(() {
            stairStart = true;
          });
        }
      } else {
        if ((hit.pose.translation.y - points.last.translation.y).abs() < 0.2) {
          setState(() {
            stairEnd = true;
          });
        }
      }
    }

    points.add(PointData(hit.pose.translation, hit.pose.rotation));
  }
}

class PointData {
  vector.Vector3 translation;
  vector.Vector4 rotation;

  PointData(this.translation, this.rotation);

  @override
  String toString() {
    return ("TRANS: ${translation.toString()} \nROT: ${rotation.toString()}");
  }
}

class AnchorData {
  double lat;
  double lng;
  double alt;

  AnchorData(this.lat, this.lng, this.alt);

  @override
  String toString() {
    return "LAT: $lat LONG: $lng";
  }
}
