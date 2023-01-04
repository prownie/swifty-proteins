import 'dart:convert';
import 'package:swifty_proteins/utils/constants.dart';
import 'package:http/http.dart' as http;
import '../model/atom.dart';
import '../model/molecule.dart';

Molecule? detectDoubleBonds(Molecule) {
  print("start");

  //place other than carbons first, because they are the more flexible due to their numbers
  for (int i = 0; i < Molecule.atomList.length; i++) {
    if (Molecule.atomList[i].name == 'C') continue;
    int? bounds = Constants.atomBonds[Molecule.atomList[i].name];
    if (bounds == null) continue; // not in bound dictionnary
    // if not enough bonds, gotta add some
    while (bounds > Molecule.atomList[i].connect.length) {
      var newList = <int>[];
      for (int connectedIndex in Molecule.atomList[i].connect) {
        int? indexBounds =
            Constants.atomBonds[Molecule.atomList[connectedIndex].name];
        if (indexBounds == null) continue;
        if (indexBounds != Molecule.atomList[connectedIndex].connect.length) {
          newList = [...Molecule.atomList[i].connect];
          newList.add(connectedIndex);
          Molecule.atomList[connectedIndex].connect.add(i);
          break;
        }
      }
      if (newList.length != 0)
        Molecule.atomList[i].connect = newList;
      else
        break;
    }
    // print(Molecule.atomList[i]);
    // print(" ||while1 bounds: " +
    //     bounds.toString() +
    //     ", actualLinks: " +
    //     Molecule.atomList[i].connect.length.toString());
  }

  // now priorize carbons who dont have 2 carbons as neighbours, because less permitives
  for (int i = 0; i < Molecule.atomList.length; i++) {
    if (Molecule.atomList[i].name != 'C') continue;
    int? bounds = Constants.atomBonds[Molecule.atomList[i].name];
    if (bounds == null) continue; // not in bound dictionnary
    // if not enough bonds, gotta add some
    while (bounds > Molecule.atomList[i].connect.length) {
      var newList = <int>[];
      bool avoid = true;
      int cpt = 0;
      for (int connectedIndex in Molecule.atomList[i].connect) {
        if (Molecule.atomList[connectedIndex].name != 'C') {
          cpt++;
          if (cpt > 1) {
            avoid = false;
            break;
          }
        }
      }
      if (avoid) break;
      for (int connectedIndex in Molecule.atomList[i].connect) {
        int? indexBounds =
            Constants.atomBonds[Molecule.atomList[connectedIndex].name];
        // print(Molecule.atomList[connectedIndex]);
        // print(indexBounds);
        if (indexBounds == null) continue;
        // print("skipped2 this");
        if (indexBounds != Molecule.atomList[connectedIndex].connect.length) {
          newList = [...Molecule.atomList[i].connect];
          newList.add(connectedIndex);
          Molecule.atomList[connectedIndex].connect.add(i);
          break;
        }
      }
      if (newList.length != 0)
        Molecule.atomList[i].connect = newList;
      else
        break;
    }
  }

  // now priorize carbons who dont have carbons only neighbours, because less permitives
  for (int i = 0; i < Molecule.atomList.length; i++) {
    if (Molecule.atomList[i].name != 'C') continue;
    int? bounds = Constants.atomBonds[Molecule.atomList[i].name];
    if (bounds == null) continue; // not in bound dictionnary
    // if not enough bonds, gotta add some
    while (bounds > Molecule.atomList[i].connect.length) {
      var newList = <int>[];
      // print("in while0");

      for (int connectedIndex in Molecule.atomList[i].connect) {
        int? indexBounds =
            Constants.atomBonds[Molecule.atomList[connectedIndex].name];
        // print(Molecule.atomList[connectedIndex]);
        // print(indexBounds);
        if (indexBounds == null) continue;
        // print("skipped2 this");
        if (indexBounds != Molecule.atomList[connectedIndex].connect.length) {
          newList = [...Molecule.atomList[i].connect];
          newList.add(connectedIndex);
          Molecule.atomList[connectedIndex].connect.add(i);
          break;
        }
      }
      if (newList.length != 0)
        Molecule.atomList[i].connect = newList;
      else
        break;
    }
  }

  return Molecule;
}

Future<Molecule?> getMolecule(String code) async {
  Molecule ret = Molecule('', '', 0, '', '');
  await initMol(code).then((value) {
    if (value != null) {
      ret = value;
    }
  });
  if (ret.name == '') {
    print("empty donc 404");
    return null;
  }
  await getAtomList(code).then((value) {
    ret.atomList = value;
  });
  //print(ret.toString());
  // return ret;
  return detectDoubleBonds(ret);
}

Future<Molecule?> initMol(String code) async {
  var result;
  result = await http
      .get(Uri.parse("https://data.rcsb.org/rest/v1/core/chemcomp/$code"));

  final parsed = jsonDecode(result.body);
  if (parsed['status'] == 404) {
    print(parsed['status']);
    return null;
  }
  Molecule mol = Molecule(
      parsed["chem_comp"]["name"],
      parsed["chem_comp"]["formula"],
      parsed["chem_comp"]["formula_weight"] as double,
      parsed["chem_comp"]["three_letter_code"],
      parsed["chem_comp"]["type"]);

  mol.atomList = await getAtomList(code);
  return mol;
}

Future<List<Atom>> getAtomList(String code) async {
  String first = code[0];
  var result = await http.get(Uri.parse(
      "https://files.rcsb.org/ligands/$first/$code/${code}_ideal.pdb"));
  final splitted = result.body.split('\n');
  List<Atom> ret = parseAtom(splitted);
  return ret;
}

List<Atom> parseAtom(List<String> splitted) {
  List<Atom> listAtom = [];
  for (int i = 0; i < splitted.length; i++) {
    //retire les espaces et met en tableau pour le traitement
    String result = splitted[i].replaceAll(RegExp(' +'), ' ');
    List<String> list = result.split(' ');
    // remplit Atom
    if (list[0] == "ATOM") {
      listAtom.add(Atom(double.parse(list[6]), double.parse(list[7]),
          double.parse(list[8]), list[11]));
    } else if (list[0] == "CONECT") {
      for (int i = 2; i < list.length; i++) {
        listAtom[int.parse(list[1]) - 1].connect.add(int.parse(list[i]) - 1);
      }
    }
  }
  return listAtom;
}
