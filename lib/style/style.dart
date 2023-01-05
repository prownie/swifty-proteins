import 'package:flutter/material.dart';

abstract class Style {
  static final rickBox = BoxDecoration(
    color: Colors.grey.shade300,
    border: Border.all(color: MyColor.rickBlue, width: 4),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
  );
  static final mortyBox = BoxDecoration(
    color: Colors.grey.shade300,
    border: Border.all(color: MyColor.mortyYellow, width: 4),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
  );
}

abstract class MyColor {
  static const background = Color(0xf0f0f0f0);
  static const mortyYellow = Color(0xffEFD96B);
  static const rickBlue = Color.fromARGB(255, 131, 210, 228);
  static const portalGreen = Color(0xff4FE51A);
}
