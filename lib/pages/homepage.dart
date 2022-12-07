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
    //print(first);
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

  void parse(List<String> splitted) {
    for (int i = 0; i < splitted.length; i++) {
      //atom
      //get next double 33 == x
      getNextDouble(splitted[i].substring(33));
      //get next double 41 == y
      getNextDouble(splitted[i].substring(41));//[49]);
      //get next double 49 == z
      getNextDouble(splitted[i].substring(49));//[76]);
      //get next string 76 == name

    }
  }
  //connect
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
