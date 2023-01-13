import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:swifty_proteins/pages/homepage.dart';
import 'package:swifty_proteins/widget/popUp404.dart';

class Initialize extends StatefulWidget {
  const Initialize({super.key});

  @override
  _InitializeState createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  @override
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
      // ignore: use_build_context_synchronously
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
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Homepage()));
      if (ret == false) {
       showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return errorLogin(context);
          });
      }
    } on PlatformException catch (e) {
      print(e);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return errorLogin(context);
          });
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
