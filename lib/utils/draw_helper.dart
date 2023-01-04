import 'package:flutter/material.dart';
import 'package:swifty_proteins/utils/constants.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;
import '../model/atom.dart';
import 'dart:math' as math;

loadFont() async {
  var loader = new three_jsm.TYPRLoader(null);
  var fontJson = await loader.loadAsync("assets/fonts/Yagora.ttf");
  return three.TYPRFont(fontJson);
}

class DrawHelper {
  late three.MeshLambertMaterial texture;
  late three.SphereGeometry sphere;
  late three.Mesh atomToDraw;
  late List<Atom> atomList;

  drawMolecule(List<Atom> list, three.Group moleculeDraw) {
    atomList = list;

    for (var atom in atomList) {
      drawAtom(atom, moleculeDraw);
      for (var indexConnectedAtom in atom.connect) {
        if (atom.connect.where((e) => e == indexConnectedAtom).length > 1) {
          drawDoubleConnect(atom, atomList[indexConnectedAtom], moleculeDraw);
        } else {
          drawConnect(atom, atomList[indexConnectedAtom], moleculeDraw);
        }
        // dispAtomName(atom, moleculeDraw, moleculeLabels);
      }
    }
  }

  drawAtom(Atom atom, three.Group moleculeDraw) {
    sphere = three.SphereGeometry(0.3);
    texture =
        three.MeshLambertMaterial({"color": Constants.atomsCPK[atom.name]});
    atomToDraw = three.Mesh(sphere, texture);
    atomToDraw.position
        .set(atom.coordinates.x, atom.coordinates.y, atom.coordinates.z);
    moleculeDraw.add(atomToDraw);
  }

  drawConnect(Atom atomX, Atom atomY, three.Group moleculeDraw) {
    var direction =
        three.Vector3().subVectors(atomY.coordinates, atomX.coordinates);
    var bond = three.CylinderGeometry(0.1, 0.1, direction.length() / 2, 6, 4);
    bond.applyMatrix4(
        new three.Matrix4().makeTranslation(0, direction.length() / 4, 0));
    bond.applyMatrix4(
        three.Matrix4().makeRotationX(three.MathUtils.degToRad(90)));

    var mesh = three.Mesh(bond,
        three.MeshLambertMaterial({"color": Constants.atomsCPK[atomX.name]}));
    mesh.position.copy(atomX.coordinates);
    mesh.lookAt(atomY.coordinates);
    moleculeDraw.add(mesh);
  }

  drawDoubleConnect(Atom atomX, Atom atomY, three.Group moleculeDraw) {
    var direction =
        three.Vector3().subVectors(atomY.coordinates, atomX.coordinates);
    var firstBond =
        three.CylinderGeometry(0.05, 0.05, direction.length() / 2, 6, 4);
    firstBond.applyMatrix4(
        new three.Matrix4().makeTranslation(0, direction.length() / 4, -0.08));
    firstBond.applyMatrix4(
        three.Matrix4().makeRotationX(three.MathUtils.degToRad(90)));
    var mesh = three.Mesh(firstBond,
        three.MeshLambertMaterial({"color": Constants.atomsCPK[atomX.name]}));
    mesh.position.copy(atomX.coordinates);
    mesh.lookAt(atomY.coordinates);
    moleculeDraw.add(mesh);

    var secondBond =
        three.CylinderGeometry(0.05, 0.05, direction.length() / 2, 6, 4);
    secondBond.applyMatrix4(
        new three.Matrix4().makeTranslation(0, direction.length() / 4, 0.08));
    secondBond.applyMatrix4(
        three.Matrix4().makeRotationX(three.MathUtils.degToRad(90)));
    mesh = three.Mesh(secondBond,
        three.MeshLambertMaterial({"color": Constants.atomsCPK[atomX.name]}));
    mesh.position.copy(atomX.coordinates);
    mesh.lookAt(atomY.coordinates);
    moleculeDraw.add(mesh);
  }

  Future<three.Mesh> dispAtomName(double x, double y, double z, String atomName,
      three.Group moleculeDraw) async {
    print('in dispatomname, name=' + atomName);
    var font = await loadFont();
    var textGeo = three.TextGeometry(atomName, {
      "font": font,
      "size": 0.5,
      "height": 0.01,
      "curveSegments": 1,
      "bevelThickness": 0.2,
      "bevelSize": 0.01,
      "bevelEnabled": true
    });
    textGeo.computeBoundingBox();

    var centerOffset =
        -0.5 * (textGeo.boundingBox!.max.x - textGeo.boundingBox!.min.x);
    // var textMesh1 = three.Mesh(textGeo,
    //     three.MeshLambertMaterial({"color": Constants.atomsCPK[atomName]}));
    var textMesh1 =
        three.Mesh(textGeo, three.MeshLambertMaterial({"color": 0xFF0000}));

    textMesh1.position.x = x;
    textMesh1.position.y = y + centerOffset;
    textMesh1.position.z = z;

    textMesh1.rotation.x = 0;
    textMesh1.rotation.y = three.Math.PI * 2;
    moleculeDraw.add(textMesh1);
    return textMesh1;
  }
}
