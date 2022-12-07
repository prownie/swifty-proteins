import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/atom.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'hello_world.dart';
import '../model/base_list.dart';
import '../style/style.dart' as s;

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
    var result = await http.get(Uri.parse(
        "https://files.rcsb.org/ligands/$first/$toSearch/${toSearch}_ideal.pdb"));
    final splitted = result.body.split('\n');
    print(result.body);
    atomList = parse(splitted);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelloWorld(atomList!)),
    );
  }

  void searchList(String toSearch)async {
String first = toSearch[0];
    var result = await http.get(Uri.parse(
        "https://files.rcsb.org/ligands/$first/$toSearch/${toSearch}_ideal.pdb"));
    final splitted = result.body.split('\n');
    print(result.body);
    atomList = parse(splitted);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelloWorld(atomList!)),
    );
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

    return listAtom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atomizator'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 30,
          ),
          TextField(
            controller: inputController,
          ),
          OutlinedButton(onPressed: search, child: const Text("search")),
          Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () => searchList(baselist[index]),
                          child: Container(
                          margin: const EdgeInsets.only(
                              top: 17, right: 30, left: 30),
                          height: 50,
                          decoration: s.Style.listBox ,
                          //color: Colors.amber[baselist[index]],
                          child: Center(child: Text(baselist[index])),
                        ));
                      },
                      itemCount: baselist.length)))
        ]));
  }
}
