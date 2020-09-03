import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  var screenHeight, screenWidth;

  String _email;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Forget Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    Text(
                      "Type your mail to reset password",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 19,
                      ),
                    )
                  ],
                ),
                top: 5,
              ),
              SizedBox(
                height: 20,
              ),
              Positioned(
                top: screenHeight * 0.5,
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.2,
                child: Container(
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: 130.0,
                    height: 50.0,
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => _forgetPassword(),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    buttonColor: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.3,
                child: Container(
                  child: TextFormField(
                    validator: validateEmail,
                    onSaved: (String value) => _email = value,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      hintText: "Email address",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  width: screenWidth * 0.8,
                ),
              )
            ],
          ),
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

  _forgetPassword() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Check your mail for resetting password"),
        ),
      );
    }
    Navigator.pop(context);
  }
}
