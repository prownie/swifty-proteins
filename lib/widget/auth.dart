import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

showLogginDialog(context) async {
  final LocalAuthentication auth = LocalAuthentication();
  //final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  //final bool canAuthenticate =
  //    canAuthenticateWithBiometrics || await auth.isDeviceSupported();

  // print(canAuthenticateWithBiometrics);
  // print(canAuthenticate);

  // final List<BiometricType> availableBiometrics =
  //     await auth.getAvailableBiometrics();

  // if (availableBiometrics.isNotEmpty) {
  //   try {
  //     final bool didAuthenticate = await auth.authenticate(
  //         localizedReason: 'Please authenticate to show account balance',
  //         options: const AuthenticationOptions(biometricOnly: true));
  //     // ···
  //   } on Exception {
  //     // ...
  //   }
  // }

  // if (availableBiometrics.contains(BiometricType.strong) ||
  //     availableBiometrics.contains(BiometricType.face)) {
  //   // Specific types of biometrics are available.
  //   // Use checks like this with caution!
  // }

  Future authenticate() async {
    //final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics();
    final bool isBiometricsAvailable = await auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print(availableBiometrics);
    if (!isBiometricsAvailable || availableBiometrics.isEmpty) return false;
    try {
      print("wegwergwergwergwergwergwergwergwer");
      var ret = await auth.authenticate(
        localizedReason: 'Scan Fingerprint To Enter',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print(ret);
      return ret;
    } on Exception {
      return;
    }
  }

  showDialog(
      context: context,
      builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 5),
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
                  const Text("please log again"),
                  const Icon(
                    Icons.fingerprint,
                    size: 100,
                  ),
                  //const CircularProgressIndicator(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 2.0, color: Colors.white),
                    ),
                    //borderSide: ButtonStyle(borde),
                    onPressed: () async {
                      bool isAuthenticated = await authenticate();
                      if (isAuthenticated) {
                        print('salut');
                        Navigator.of(context).pop();
                      } else {
                        Container();
                      }
                    },
                    //() {
                    //  Navigator.of(context).pop();
                    //},
                    child: const Text(
                      'loggin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ))));
}
