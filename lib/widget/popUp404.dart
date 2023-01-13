import 'dart:io';

import 'package:flutter/material.dart';
import 'package:swifty_proteins/model/molecule.dart';

Widget error404(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Colors.red, width: 5),
      borderRadius: BorderRadius.circular(20),
    ),
    //title: const Text("Error",style: TextStyle(color:Colors.red),),
    child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(500))),
        height: 220,
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber,
              color: Colors.red,
              size: 100,
            ),
            const Text(
              'This ligand doesn\'t exist please try another one',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2.0, color: Colors.black),
              ),
              //borderSide: ButtonStyle(borde),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
            //Text(mol.weight),
          ],
        )),
  );
}

Widget errorLogin(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Colors.red, width: 5),
      borderRadius: BorderRadius.circular(20),
    ),
    //title: const Text("Error",style: TextStyle(color:Colors.red),),
    child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(500))),
        height: 220,
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber,
              color: Colors.red,
              size: 100,
            ),
            const Text(
              'Authentification failed please close the app and try again',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2.0, color: Colors.black),
              ),
              //borderSide: ButtonStyle(borde),
              onPressed: () {
                exit(1);
              },
              child: const Text(
                'Close app',
                style: TextStyle(color: Colors.black),
              ),
            ),
            //Text(mol.weight),
          ],
        )),
  );
}
