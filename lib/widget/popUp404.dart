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
              style: TextStyle(color: Colors.red, fontSize: 18,),
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 2.0, color: Colors.white),
              ),
              //borderSide: ButtonStyle(borde),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
            //Text(mol.weight),
          ],
        )),
  );
}

// Future errorAuth(context) {
//   return showDialog(
//     context: context,
//     builder: (context) =>
//         Dialog(
//     shape: RoundedRectangleBorder(
//       side: const BorderSide(color: Colors.red, width: 5),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     //title: const Text("Error",style: TextStyle(color:Colors.red),),
//     child: Container(
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(500))),
//         height: 220,
//         padding: EdgeInsets.all(10),
//         width: double.infinity,
//         child: Column(
//           children: [
//             const Icon(
//               Icons.warning_amber,
//               color: Colors.red,
//               size: 100,
//             ),
//             const Text(
//               'too many or bad attempts please close the app and restart in 30 seconds',
//               style: TextStyle(color: Colors.red, fontSize: 18,),
//               textAlign: TextAlign.center,
//             ),
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(width: 2.0, color: Colors.white),
//               ),
//               //borderSide: ButtonStyle(borde),
//               onPressed: () {
//                 exit(1);
//               },
//               child: const Text(
//                 'Quit Application',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             //Text(mol.weight),
//           ],
//         )),
//   ));
// }
