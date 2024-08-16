// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

RouteModel routeModelFromJson(String str) => RouteModel.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {
  RouteModel({
    this.anchorPoint,
    this.bearing,
    this.routePoints,
  });

  AnchorPoint anchorPoint;
  double bearing;
  List<RoutePoint> routePoints;

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
    anchorPoint: json["anchorPoint"] == null ? null : AnchorPoint.fromJson(json["anchorPoint"]),
    bearing: json["bearing"] == null ? null : json["bearing"].toDouble(),
    routePoints: json["routePoints"] == null ? null : List<RoutePoint>.from(json["routePoints"].map((x) => RoutePoint.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "anchorPoint": anchorPoint == null ? null : anchorPoint.toJson(),
    "bearing": bearing == null ? null : bearing,
    "routePoints": routePoints == null ? null : List<dynamic>.from(routePoints.map((x) => x.toJson())),
  };
}

class AnchorPoint {
  AnchorPoint({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory AnchorPoint.fromJson(Map<String, dynamic> json) => AnchorPoint(
    latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
    longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
  };
}

class RoutePoint {
  RoutePoint({
    this.translation,
    this.rotation,
  });

  Rotation translation;
  Rotation rotation;

  factory RoutePoint.fromJson(Map<String, dynamic> json) => RoutePoint(
    translation: json["translation"] == null ? null : Rotation.fromJson(json["translation"]),
    rotation: json["rotation"] == null ? null : Rotation.fromJson(json["rotation"]),
  );

  Map<String, dynamic> toJson() => {
    "translation": translation == null ? null : translation.toJson(),
    "rotation": rotation == null ? null : rotation.toJson(),
  };
}

class Rotation {
  Rotation({
    this.x,
    this.y,
    this.z,
    this.w,
  });

  double x;
  double y;
  double z;
  double w;

  factory Rotation.fromJson(Map<String, dynamic> json) => Rotation(
    x: json["x"] == null ? null : json["x"].toDouble(),
    y: json["y"] == null ? null : json["y"].toDouble(),
    z: json["z"] == null ? null : json["z"].toDouble(),
    w: json["w"] == null ? null : json["w"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "x": x == null ? null : x,
    "y": y == null ? null : y,
    "z": z == null ? null : z,
    "w": w == null ? null : w,
  };
}