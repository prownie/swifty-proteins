import 'package:flutter/material.dart';
import 'package:swifty_proteins/utils/constants.dart';
import 'package:three_dart/three_dart.dart' as three;
import '../model/atom.dart';
import 'dart:math' as math;

class DrawHelper {
  late three.MeshBasicMaterial texture;
  late three.SphereGeometry sphere;
  late three.Mesh atomToDraw;
  late List<Atom> atomList;

  drawMolecule(List<Atom> list, three.Group moleculeDraw) {
    atomList = list;

    for (var atom in atomList) {
      drawAtom(atom, moleculeDraw);
      for (var indexConnectedAtom in atom.connect) {
        drawConnect(atom.coordinates, atomList[indexConnectedAtom].coordinates,
            moleculeDraw);
      }
    }
  }

  drawAtom(Atom atom, three.Group moleculeDraw) {
    sphere = three.SphereGeometry(0.3);
    texture = three.MeshBasicMaterial({"color": Constants.atomsCPK[atom.name]});
    atomToDraw = three.Mesh(sphere, texture);
    atomToDraw.position
        .set(atom.coordinates.x, atom.coordinates.y, atom.coordinates.z);
    moleculeDraw.add(atomToDraw);
  }

  drawConnect(coordinatesX, coordinatesY, three.Group moleculeDraw) {
    var direction = three.Vector3().subVectors(coordinatesY, coordinatesX);
    var geometry = three.CylinderGeometry(0.1, 0.1, direction.length(), 6, 4);
    geometry.applyMatrix4(
        new three.Matrix4().makeTranslation(0, direction.length() / 2, 0));
    geometry.applyMatrix4(
        three.Matrix4().makeRotationX(three.MathUtils.degToRad(90)));

    var mesh =
        three.Mesh(geometry, three.MeshBasicMaterial({"color": 0x0000ff}));
    mesh.position.copy(coordinatesX);
    mesh.lookAt(coordinatesY);
    moleculeDraw.add(mesh);
  }
}
