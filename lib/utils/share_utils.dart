import 'package:share_plus/share_plus.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../style/style.dart' as s;

Future saveScreen1() async {
  await [Permission.manageExternalStorage].request();
  await [Permission.storage].request();
  var status = await Permission.manageExternalStorage.status;
  var status1 = await Permission.storage.status;
  String? path = await NativeScreenshot.takeScreenshot();
  //show toast to notify screen succesfully
  Fluttertoast.showToast(
      msg: "Morty took a screenshot",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<void> shareScreen(context) async {
  await [Permission.manageExternalStorage].request();
  await [Permission.storage].request();
  var status = await Permission.manageExternalStorage.status;
  var status1 = await Permission.storage.status;
  String? path = await NativeScreenshot.takeScreenshot();

  double maxWidth = MediaQuery.of(context).size.width;
  double maxHeight = MediaQuery.of(context).size.height;
  TextEditingController controller = TextEditingController();
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          //title: const Text("Error",style: TextStyle(color:Colors.red),),
          child: Container(
              //decoration: const BoxDecoration(
              //    borderRadius: BorderRadius.all(Radius.circular(500))),
              height: maxHeight * 0.55,
              width: maxWidth * 0.85,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: maxHeight * 0.3,
                    width: maxWidth * 0.8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: s.MyColor.mortyYellow,
                    ),
                    child: Column(children: [
                      const Text(
                          "Morty wants to send the screenshot with a nice little message."),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Type your message",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side:
                              const BorderSide(width: 1.0 /*, color: Colors.*/),
                        ),
                        onPressed: () async {
                          if (path != null) {
                            await Share.shareXFiles([XFile(path)],text: controller.text);
                            await File(path).delete();
                          }
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'I\'m a Morty',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: maxHeight * 0.2,
                    width: maxWidth * 0.8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: s.MyColor.rickBlue,
                    ),
                    child: Column(
                      children: [
                        Text("Rick doesn't care about messages."),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                width: 1.0 /*, color: Colors.*/),
                          ),
                          onPressed: () async {
                            if (path != null) {
                              await Share.shareXFiles([XFile(path)]);
                              await File(path).delete();
                            }
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'I\'m a Rick',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      });

  //dialog ask for message

  //if (path != null) {
  //  await Share.shareXFiles([XFile(path)], text: 'Great picture');
  //  await File(path).delete();
  //}
  //show toast to notify screen succesfully
}
