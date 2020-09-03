import 'package:bracu_tracthon/screens/login.dart';
import 'package:bracu_tracthon/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _checkState(),
    );
  }

  Widget _checkState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        } else {
          if (snapshot.hasData) {
            return MainPage(
              mFirebaseUser: (snapshot.data),
            );
          } else {
            return LoginPage();
          }
        }
      },
    );
  }

  Widget loading() {
    return Scaffold(
      body: Container(
        child: SpinKitRing(color: Colors.blue),
      ),
    );
  }
}
