import 'package:flutter/material.dart';
import 'package:swifty_proteins/model/molecule.dart';
import '';

Widget buildCard(context, Molecule mol) {
  //Molecule molecule = getMocule(mol);

  return AlertDialog(
    content: Column(
      children: [
        Text("formula: ${mol.formula}\n"),
        Text("name: ${mol.name}\n"),
        Text("type: ${mol.type}\n"),
        Text("letter code: ${mol.letterCode}\n"),
        //Text(mol.weight),
      ],
    ),
    actions: <Widget>[
      OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        //textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}
