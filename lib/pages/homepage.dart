import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/atom.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'hello_world.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController inputController = TextEditingController();
  List<Atom>? atomList;
  @override
  void initState() {
    inputController.text = "CUL";
    super.initState();
  }

  void search() async {
    String toSearch = inputController.text;
    String first = toSearch[0];
    //print(first);
    var result = await http.get(Uri.parse(
        "https://files.rcsb.org/ligands/$first/$toSearch/${toSearch}_ideal.pdb"));
    final splitted = result.body.split('\n');
    print(result.body);
    atomList = parse(splitted);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelloWorld(atomList!)),
    );
    //print(splitted[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atomizator'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: inputController,
          ),
          OutlinedButton(onPressed: search, child: const Text("search")),
        ]));
  }

  List<Atom> parse(List<String> splitted) {
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

    //test
    // for (int i = 0; i < listAtom.length; i++) {
    //   print(listAtom[i].toString());
    // }

    return listAtom;
  }
  //connect
  //- 1

  //}
  //final List<Atom> res = [];
  //return res;

  double getNextDouble(String str) {
    int i = 0;
    while (str[i] == ' ') {
      i++;
    }
    int y = i;
    while (str[y] != ' ') {
      y++;
    }
    String res = str.substring(i, y);
    print("$i $y .    $res");
    return 0.000;
  }
}
