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
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    print(maxHeight);
    double minHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: const Text('Atomizator'),
        // ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                  height: maxHeight * 0.08,
                  top: (selected == 0) ? maxHeight * 0.25 : maxHeight * 0.03,
                  left: 10,
                  right: 10,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 0;
                      });
                    },
                    child: const Center(child: Text('Atomizator')),
                  ),
                ),
                AnimatedPositioned(
                  height: (selected > 0)
                      ? (selected == 1)
                          ? maxHeight * 0.78
                          : maxHeight * 0.08
                      : maxHeight * 0.08, 
                  top: (selected > 0) ? maxHeight * 0.1 : maxHeight * 0.37,
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
                      child: searchWidget(),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  height: (selected == 2) ? maxHeight * 0.78 : maxHeight * 0.08,
                  top: (selected == 0)
                      ? maxHeight * 0.47
                      : (selected == 1)
                          ? maxHeight * 0.90
                          : maxHeight * 0.2,
                  left: 10,
                  right: 10,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 2;
                      });
                    },
                    child: Container(
                      decoration: s.Style.listBox,
                      child: listWidget(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
  
  Widget listWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //selected == 0 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.menu), Text('Find in list')]),
        selected == 2
            ? Expanded(
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
            : const SizedBox(),
      ],
    );
  }

  Widget searchWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.search), Text('Custom search')]),
        selected == 1
            ? Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        margin: const EdgeInsets.all(15),
                        child: Column(children: [
                          TextField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                            controller: inputController,
                          ),
                          OutlinedButton(
                              onPressed: loadMolSearch,
                              child: const Text("search")),
                        ]))))
            : const SizedBox(),
      ],
    );
  }
}
