import 'package:flutter/material.dart';
import '../model/atom.dart';
import '../model/molecule.dart';
import 'hello_world.dart';
import '../model/base_list.dart';
import '../style/style.dart' as s;
import '../utils/parse.dart';
import '../widget/moleculeCard.dart';

var lightGrey = Color.fromARGB(210, 128, 128, 128);

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController inputController = TextEditingController();
  List<Atom>? atomList;
  late Molecule molCard;
  late bool load;
  @override
  void initState() {
    inputController.text = "010";
    load = false;
    molCard = Molecule('', '', 0, '', '');
    super.initState();
  }

  void loadMol(String str) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Loading"),
                ],
              ),
            ));
      },
    );
    getMolecule(str).then((value) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HelloWorld(value)),
      );
    });
  }

  void loadMolSearch() {
    String str = inputController.text;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: lightGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Loading"),
                ],
              ),
            ));
      },
    );
    getMolecule(str).then((value) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HelloWorld(value)),
      );
    });
  }

  //print(molCard.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atomizator'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 30,),
          TextField(
            controller: inputController,
          ),
          OutlinedButton(
              onPressed: loadMolSearch, child: const Text("search")),
          Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () => loadMol(baselist[index]),
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
                                  ]),
                            ));
                      },
                      itemCount: baselist.length)))
        ]));
  }
}
