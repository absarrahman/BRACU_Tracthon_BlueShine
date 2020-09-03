import 'package:bracu_tracthon/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _firstName,
      _lastName,
      _address,
      _area,
      _city,
      _zipCode,
      _birthday,
      _nId;
  var screenHeight, screenWidth;
  DateTime _dateTime;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Text(
                "Personal Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              top: 10,
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
              bottom: screenHeight * 0.05,
              child: Container(
                alignment: Alignment.center,
                child: ButtonTheme(
                  minWidth: 130.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => _nextPage(),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  buttonColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth - 100,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderOnForeground: true,
                    elevation: 10,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: screenHeight * 0.06,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                inputField("First Name", 0.28),
                                inputField("Last Name", 0.28),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.027,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Select your birthday:"),
                                  InkWell(
                                    onTap: () => {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime.now(),
                                      ).then((onValue) {
                                        _dateTime = onValue;
                                        _birthday = _dateTime.toString();
                                      })
                                    },
                                    child: Text(
                                      "Tap here",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 10.0, right: 20.0),
                                child: inputField("Street Address", 0.65),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  top: 10.0,
                                  right: 20.0,
                                ),
                                child: inputField("Area", 0.65),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.027,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                inputField("City", 0.28),
                                inputField("Zip", 0.28),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.027,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 10.0, right: 20.0),
                                child: inputField("National ID", 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(String type, double width) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: TextFormField(
        validator: validateFields,
        keyboardType: _keyboardType(type),
        onSaved: (String value) {
          if (type == "First Name") {
            this._firstName = value;
          } else if (type == "Last Name") {
            this._lastName = value;
          } else if (type == "Street Address") {
            this._address = value;
          } else if (type == "Area") {
            this._area = value;
          } else if (type == "City") {
            this._city = value;
          } else if (type == "National ID") {
            this._nId = value;
          } else {
            this._zipCode = value;
          }
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: type,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      width: screenWidth * width,
    );
  }

  TextInputType _keyboardType(String type) {
    if (type == "Zip") {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }

  String validateFields(String value) {
    if (value.length == 0) {
      return "You cannot keep this field blank";
    }
    return null;
  }

  _nextPage() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterUserPage(
            firstName: _firstName,
            lastName: _lastName,
            address: _address,
            area: _area,
            city: _city,
            birthday: _birthday,
            zipCode: _zipCode,
            nId: _nId,
          ),
        ),
      );
    }
  }
}

class RegisterUserPage extends StatefulWidget {
  final String firstName, lastName, address, area, city, zipCode, birthday, nId;

  const RegisterUserPage(
      {Key key,
      this.firstName,
      this.lastName,
      this.address,
      this.area,
      this.city,
      this.zipCode,
      this.birthday,
      this.nId})
      : super(key: key);

  @override
  _RegisterUserPageState createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  var screenHeight, screenWidth;
  String email, password, confirmPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Text(
                "Let's Get Started",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              top: 10,
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
              bottom: screenHeight * 0.05,
              child: Container(
                alignment: Alignment.center,
                child: ButtonTheme(
                  minWidth: 130.0,
                  height: 50.0,
                  child: RaisedButton(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => signUpAccount(),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  buttonColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth - 100,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderOnForeground: true,
                    elevation: 10,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.09,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.email),
                                inputField("Email", 0.6),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.027,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.vpn_key),
                                inputField("Password", 0.6),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.027,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.vpn_key),
                                inputField("Confirm Password", 0.6),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField(String type, double width) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: TextFormField(
        validator: type == "Email" ? validateEmail : validatePassword,
        obscureText: ((type == "Password") || (type == "Confirm Password"))
            ? true
            : false,
        onSaved: (String value) {
          if (type == "Email") {
            this.email = value;
          } else if (type == "Password") {
            this.password = value;
          } else {
            this.confirmPassword = value;
          }
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: type,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      width: screenWidth * width,
    );
  }

  signUpAccount() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        FirebaseUser user = ((await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user);
        user.sendEmailVerification();
        Firestore.instance
            .collection('Users')
            .document(user.uid)
            .setData(User(
                    widget.firstName,
                    widget.lastName,
                    widget.address,
                    widget.area,
                    widget.city,
                    widget.zipCode,
                    widget.birthday,
                    email,
                    widget.nId)
                .toJson())
            .catchError((e) {
          debugPrint(e.toString());
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } catch (e) {
        print(e.message);
      }
    }
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
}
