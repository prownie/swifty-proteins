import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart' as three;

class Atom {
  late List<int> connect;
  late three.Vector3 coordinates;
  final String name;

  Atom(
    double x,
    double y,
    double z,
    this.name,
  ) {
    coordinates = three.Vector3(x, y, z);
    connect = [];
  }

  //Atom(double x, double y, double z, this.name, this.connect) {
   // coordinates = three.Vector3(x, y, z);
  //}

  @override
  String toString() {
    return "$name x:${coordinates.x} y:${coordinates.y} z:${coordinates.z} connect:$connect";
  }
}
