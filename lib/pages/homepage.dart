import 'package:flutter/material.dart';
import '../model/atom.dart';
import '../model/molecule.dart';
import 'hello_world.dart';
import '../model/base_list.dart';
import '../style/style.dart' as s;
import '../utils/parse.dart';
import '../widget/moleculeCard.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController inputController = TextEditingController();
  List<Atom>? atomList;
  late Molecule molCard;
  @override
  void initState() {
    inputController.text = "CUL";
    molCard = Molecule('', '', 0, '', '');
    super.initState();
  }

  void renderCard(String str) {
    getMolecule(str).then((value) {
      molCard = value;
      showDialog(
        context: context,
        builder: (BuildContext context) => buildCard(context, molCard),
      );
    });
  }
  //print(molCard.toString());

  void newMol() async {
    Molecule mol = await getMolecule(inputController.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelloWorld(mol)),
    );
  }

  void newMolInList(String str) async {
    Molecule mol = await getMolecule(str);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelloWorld(mol)),
    );
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
          OutlinedButton(onPressed: newMol, child: const Text("search")),
          Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () => newMolInList(baselist[index]),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 17, right: 30, left: 30),
                              height: 50,
                              decoration: s.Style.listBox,
                              //color: Colors.amber[baselist[index]],
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(baselist[index]),
                                    IconButton(
                                      icon: const Icon(Icons.info),
                                      onPressed: () {
                                        renderCard(baselist[
                                            index]);
                                      },
                                    )
                                  ]),
                            ));
                      },
                      itemCount: baselist.length)))
        ]));
  }
}
