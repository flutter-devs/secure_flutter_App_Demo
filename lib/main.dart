import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secure_application/secure_application.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SecureApplication(
      nativeRemoveDelay: 100,
      autoUnlockNative: true,
      child: SecureGate(
        blurr: 30,
        opacity: 0.3,
        lockedBuilder: (context, secureNotifier) => Center(
          child: FlatButton(
            color: Colors.cyan,
            child: Text(
              'UNLOCK WITH FINGERPRINT',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              final LocalAuthentication auth = LocalAuthentication();
              bool canCheckBiometrics = false;
              try {
                canCheckBiometrics = await auth.canCheckBiometrics;
              } catch (e) {
                print("error biometrics $e");
              }

              print("biometric is available: $canCheckBiometrics");

              // enumerate biometric technologies
              List<BiometricType> availableBiometrics;
              try {
                availableBiometrics = await auth.getAvailableBiometrics();
              } catch (e) {
                print("error enumerate biometrics $e");
              }

              print("following biometrics are available");
              if (availableBiometrics.isNotEmpty) {
                availableBiometrics.forEach((ab) {
                  print("\ttech: $ab");
                });
              } else {
                print("no biometrics are available");
              }

              // authenticate with biometrics
              bool authenticated = false;
              try {
                authenticated = await auth.authenticateWithBiometrics(
                    localizedReason: 'Touch your finger on the sensor to login',
                    useErrorDialogs: true,
                    stickyAuth: false,
                    androidAuthStrings:
                        AndroidAuthMessages(signInTitle: "Login to HomePage"));
              } catch (e) {
                print("error using biometric auth: $e");
              }
              authenticated
                  ? secureNotifier.authSuccess(unlock: true)
                  : print("fail");
            },
          ),
        ),
        child: Builder(builder: (context) {
          return ValueListenableBuilder<SecureApplicationState>(
            valueListenable: SecureApplicationProvider.of(context),
            builder: (context, state, _) => state.secured
                ? MaterialApp(home: HomePage())
                : Scaffold(
                    body: Center(
                      child: RaisedButton(
                        onPressed: () async {
                          final LocalAuthentication auth =
                              LocalAuthentication();
                          bool canCheckBiometrics = false;
                          try {
                            canCheckBiometrics = await auth.canCheckBiometrics;
                          } catch (e) {
                            print("error biome trics $e");
                          }

                          print("biometric is available: $canCheckBiometrics");

                          // enumerate biometric technologies
                          List<BiometricType> availableBiometrics;
                          try {
                            availableBiometrics =
                                await auth.getAvailableBiometrics();
                          } catch (e) {
                            print("error enumerate biometrics $e");
                          }

                          print("following biometrics are available");
                          if (availableBiometrics.isNotEmpty) {
                            availableBiometrics.forEach((ab) {
                              print("\ttech: $ab");
                            });
                          } else {
                            print("no biometrics are available");
                          }

                          // authenticate with biometrics
                          bool authenticated = false;
                          try {
                            authenticated = await auth.authenticateWithBiometrics(
                                localizedReason:
                                    'Touch your finger on the sensor to login',
                                useErrorDialogs: true,
                                stickyAuth: false,
                                androidAuthStrings: AndroidAuthMessages(
                                    signInTitle: "Login to HomePage"));
                          } catch (e) {
                            print("error using biometric auth: $e");
                          }
                          authenticated
                              ? SecureApplicationProvider.of(context).secure()
                              : print("fail");
                        },
                        color: Colors.cyan,
                        child: Text(
                          'UNLOCK WITH FINGERPRINT',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
          );
        }),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure App demo"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return NewPage();
            }));
          },
          child: Text("Test on new page"),
        ),
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New PAGE")),
      body: Center(child: Text("Hello")),
    );
  }
}
