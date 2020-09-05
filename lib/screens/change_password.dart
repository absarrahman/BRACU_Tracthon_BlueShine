import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  var screenHeight, screenWidth;

  String _currentPassword, _newPassword;

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
      body: SingleChildScrollView(
        child: Form(
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
                        "Change Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Text(
                        "Type your old password for confirmation",
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
                        onPressed: () => _changePassword(),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      buttonColor: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.25,
                  child: Container(
                    child: TextFormField(
                      validator: validatePassword,
                      onSaved: (String value) => _currentPassword = value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Current password",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    width: screenWidth * 0.8,
                  ),
                ),
                Positioned(
                  top: screenHeight/2.9,
                  child: Container(
                    child: TextFormField(
                      validator: validatePassword,
                      onSaved: (String value) => _newPassword = value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "New password",
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
      ),
    );
  }

  String validatePassword(String value) {
    if (value.length >= 8) {
      return null;
    }
    return "Password length should be at least\n 8 characters";
  }
  _changePassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

      AuthCredential authCredential = EmailAuthProvider.getCredential(
        email: firebaseUser.email,
        password: _currentPassword,
      );

      firebaseUser.reauthenticateWithCredential(authCredential).then((onValue) {
        onValue.user.updatePassword(_newPassword).then((data){
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Password updated successfully"),
            ),
          );
          Navigator.pop(context);

        }).catchError((e)=>print(e.message));
      });
    }
  }

}

