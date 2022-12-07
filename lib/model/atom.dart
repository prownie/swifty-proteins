import 'package:flutter/material.dart';

class Atom {
  final List<int> connect;
  final double x;
  final double y;
  final double z;
  final String name;

  Atom(this.x, this.y, this.z, this.name, this.connect);

  @override
  String toString() {
    return "$name x:$x y:$y z:$z connect:$connect";
  }
}
