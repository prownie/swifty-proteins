import 'package:flutter/material.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'atom.dart';

class Molecule {
  late String name;
  late String formula;
  late double weight;
  late String letterCode;
  late String type;
  late List<Atom> atomList;

  

  Molecule(this.name, this.formula, this.weight, this.letterCode, this.type) {
    atomList = [];
  }

  @override
  String toString() {
    return"name: $name\nformula: $formula\nweight: $weight\ncode: $letterCode\ntype: $type";
  }
}
