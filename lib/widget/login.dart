import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:swifty_proteins/pages/homepage.dart';

class Initialize extends StatefulWidget {
  _InitializeState createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    final bool isBiometricsAvailable = await auth.isDeviceSupported();
    print(isBiometricsAvailable);
    if (!isBiometricsAvailable || availableBiometrics.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
      return;
    }

    try {
      var ret = await auth.authenticate(
        localizedReason: 'Rick needs your fingerprint for his database',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
