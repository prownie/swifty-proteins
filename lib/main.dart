import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:swifty_proteins/widget/login.dart';
import 'pages/hello_world.dart';
import 'pages/homepage.dart';
import 'widget/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      // ignore: unrelated_type_equality_checks
      home:Initialize(),
    );
  }
}
