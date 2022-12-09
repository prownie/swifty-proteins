import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/atom.dart';
import '../model/molecule.dart';

Future<Molecule> getMolecule(String code) async {
  late Molecule ret = Molecule('', '', 0, '', '');
  await initMol(code).then((value) {
    ret = value;
  });
  await getAtomList(code).then((value) {
    ret.atomList = value;
  });
  //print(ret.toString());
  return ret;
}

Future<Molecule> initMol(String code) async {
  var result;
  result = await http
      .get(Uri.parse("https://data.rcsb.org/rest/v1/core/chemcomp/$code"));
  final parsed = jsonDecode(result.body);

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
