import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/atom.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    inputController.text = "CUL";
    super.initState();
  }

  void search() async {
    String toSearch = inputController.text;
    String first = toSearch[0];
    print(first);
    var result = await http.get(Uri.parse(
        "https://files.rcsb.org/ligands/$first/$toSearch/${toSearch}_ideal.pdb"));
    final splitted = result.body.split('\n');
    parse(splitted);

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
    List<Atom> res = [];
    for (int i = 0; i < splitted.length; i++) {
      //atom
      if (splitted[i].startsWith("ATOM")) {
        int y = 0;
        for (; y < splitted[i].length; y++) {
          print("$y $splitted[i][y]");
        }
      }
      //connect
    }
    return res;
  }
}
