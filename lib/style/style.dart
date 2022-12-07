import 'package:flutter/material.dart';

abstract class Style {
  static final listBox = BoxDecoration(
    color: Colors.grey.shade800,
    border: Border.all(color: Colors.black, width: 2),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}
