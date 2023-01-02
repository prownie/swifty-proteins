import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../model/atom.dart';
import '../model/molecule.dart';
import 'hello_world.dart';
import '../model/base_list.dart';
import '../style/style.dart' as s;
import '../utils/parse.dart';
import '../widget/moleculeCard.dart';
import '../widget/popUp404.dart';
// import 'package:local_auth/error_codes.dart' as auth_error;

var lightGrey = Color.fromARGB(210, 128, 128, 128);

Future<dynamic> _authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();
  final List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
  final bool isBiometricsAvailable = await auth.isDeviceSupported();
  if (!isBiometricsAvailable || availableBiometrics.isEmpty) return;

  try {
    var ret = await auth.authenticate(
      localizedReason: 'Scan Fingerprint To Enter',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
    if (ret == false) {
      exit(1);
    }
  } on PlatformException catch (e) {
    print(e);
    exit(1);
    // if (e.code == auth_error.lockedOut) {
    // return errorAuth(BuildContext);
    // }
    //exit(0);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> with WidgetsBindingObserver {
  TextEditingController inputController = TextEditingController();
  List<Atom>? atomList;
  late Molecule molCard;
  late bool load;
  final _formKey = GlobalKey<FormState>();
  final List<AppLifecycleState> _stateHistoryList = <AppLifecycleState>[];

  //animated
  // 0 = default
  // 1 = search
  // 2 = list
  int selected = 0;

  @override
  void initState() {
    inputController.text = "";
    load = false;
    molCard = Molecule('', '', 0, '', '');
    selected = 0;

    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      _stateHistoryList.add(WidgetsBinding.instance.lifecycleState!);
    }
    //selected = false;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() async {
      _stateHistoryList.add(state);
      print(state);
      if (_stateHistoryList[_stateHistoryList.length - 1] ==
          AppLifecycleState.resumed) {
        await _authenticate();
      }
    });
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
      if (value == null) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return error404(context);
            });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelloWorld(value)),
        );
      }
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
      if (value == null) {
        print("go pop up ");
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HelloWorld(value)),
        );
      }
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'R&M data',
                            style: TextStyle(fontSize: 25),
                          ),
                          Divider(
                            height: 3,
                            color: Colors.black,
                          ),
                          Text(
                              'A quick access to your characters favorites molecules'),
                        ]),
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
                      decoration: s.Style.rickBox,
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
                      decoration: s.Style.mortyBox,
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
                                decoration: s.Style.mortyBox,
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Autocomplete<String>(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return baselist.where((String option) {
                                    return option.contains(
                                        textEditingValue.text.toUpperCase());
                                  });
                                },
                                fieldViewBuilder: (BuildContext context,
                                    inputController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        validator: (value) {
                                          final validCharacters = RegExp(
                                              r'^[a-zA-Z0-9]+$'); // alphanum
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          } else if (!validCharacters
                                              .hasMatch(inputController.text)) {
                                            return "ligand code contain only alphanum character";
                                          } else if (inputController
                                                  .text.length !=
                                              3) {
                                            return "ligand code contain exactly 3 character";
                                          }
                                          return null;
                                        },
                                        controller: inputController,
                                        decoration: const InputDecoration(
                                          hintText: "Type or select from list",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                        ),
                                        focusNode: focusNode,
                                        onFieldSubmitted: (String value) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            onFieldSubmitted();
                                            loadMol(value);
                                          }
                                        },
                                      ));
                                },
                                onSelected: (String selection) {
                                  loadMol(selection);
                                },
                              )
                            ]))))
            : const SizedBox(),
      ],
    );
  }
}
