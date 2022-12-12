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

  //animated
  // 0 = default
  // 1 = search
  // 2 = list
  int selected = 0;

  @override
  void initState() {
    inputController.text = "010";
    load = false;
    molCard = Molecule('', '', 0, '', '');
    selected = 0;
    //selected = false;
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
       // appBar: AppBar(
       //   title: const Text('Atomizator'),
       // ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height -
                20, //TODO height of safe area to fit screen
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  //width: selected ? 200.0 : 200.0,
                  height: 40,//selected ? 300.0 : 50.0,
                  top: (selected == 0) ? 150 : 0.0,
                  left: 10,
                  right: 10,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 1;
                      });
                    },
                    child: const Center(child: Text('Atomizator')),
                    
                  ),
                ),
                AnimatedPositioned(
                  //width: selected ? 200.0 : 200.0,
                  height: (selected > 0) ? (selected == 1) ?  480 : 50 : 50,//selected ? 300.0 : 50.0,
                  top: (selected > 0) ? 40 : 200.0,
                  left: 10,
                  right: 10,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 1;
                      });
                    },
                    child: Container(
                      decoration: s.Style.listBox,
                      //color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Icon(Icons.search),
                          Text('Custom search')
                        ]),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  //width: selected ? 200.0 : 200.0,
                  height: (selected  == 2) ? 480 : 50,
                  top: (selected  == 0) ? 260.0 : (selected == 1) ? 530: 100,
                  left: 10,
                  right: 10,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        //if (selected)
                        selected = 2;
                      });
                    },
                    child: Container(
                      decoration: s.Style.listBox,
                      //color:Colors.red,
                      //color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:const [
                          Icon(Icons.menu),
                          Text('Find in list')
                        ]),
                    ),
                  ),
                ),
              ],
            ),
          )

          //const SizedBox(
          //  height: 30,
          //),

          //TextField(
          //  controller: inputController,
          //),
          //OutlinedButton(onPressed: loadMolSearch, child: const Text("search")),
          //Expanded(
          //    child: Scrollbar(
          //        child: ListView.builder(
          //            itemBuilder: (BuildContext context, int index) {
          //              return InkWell(
          //                  onTap: () => loadMol(baselist[index]),
          //                  child: Container(
          //                    margin: const EdgeInsets.only(
          //                        top: 17, right: 30, left: 30),
          //                    height: 50,
          //                    decoration: s.Style.listBox,
          //                    //color: Colors.amber[baselist[index]],
          //                    child: Row(
          //                        mainAxisAlignment: MainAxisAlignment.center,
          //                        children: [
          //                          Text(baselist[index]),
          //                        ]),
          //                  ));
          //            },
          //            itemCount: baselist.length)))
          // ]
        ]));
  }
}
