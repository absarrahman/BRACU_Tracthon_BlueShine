import 'dart:io';

import 'package:bracu_tracthon/screens/forget_password.dart';
import 'package:bracu_tracthon/screens/main_page.dart';
import 'package:bracu_tracthon/screens/register_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => exit(0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.email),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      validator: validateEmail,
                      onSaved: (String value) => _email = value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email address",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    width: 250,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.vpn_key),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      validator: validatePassword,
                      obscureText: true,
                      onSaved: (String value) => _password = value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    width: 250,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: 130.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => _signIn(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                buttonColor: Colors.blue,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              child: InkWell(
                child: Text(
                  "Forget password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgetPasswordPage(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.08,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Need an account?"),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () => _registerPage(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String validateEmail(String value) {
    if (value.contains("@")) {
      return null;
    }
    return "Invalid email";
  }

  String validatePassword(String value) {
    if (value.length >= 8) {
      return null;
    }
    return "Password length should be at least\n 8 characters";
  }

  _registerPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        FirebaseUser user = ((await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _email.trim(), password: _password))
            .user);
        print(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainPage(
                    mFirebaseUser: user,
                  )),
        );
      } catch (e) {
        print(e.message);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            title: Text(
              "Emergency App",
              textAlign: TextAlign.center,
            ),
            content: Text(
              e.message,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Ok",
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }
}
