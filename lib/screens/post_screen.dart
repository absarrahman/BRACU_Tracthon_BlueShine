import 'package:bracu_tracthon/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

class PostViewPage extends StatelessWidget {
  final title, postDetails;
  final bool isSolved;

  PostViewPage({this.title, this.postDetails, this.isSolved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Text(postDetails),
    );
  }
}

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String _title, _postDetails;
  var screenHeight, screenWidth;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "New Issue",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.027,
              ),
              Center(
                child: Container(
                  child: TextFormField(
                    validator: validateTitle,
                    onSaved: (String value) => _title = value,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[200],
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      hintText: "Title",
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  width: screenWidth * 0.9,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Container(
                    height: screenHeight * 0.6,
                    child: TextFormField(
                      validator: validateDescription,
                      maxLines: 1200,
                      onSaved: (String value) => _postDetails = value,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.blue[200],
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        hintText: "Description",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                    width: screenWidth * 0.9,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: 130.0,
                    height: 50.0,
                    child: RaisedButton(
                      child: Text(
                        "Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => postPopDialogue(),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    buttonColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  postPopDialogue() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        title: Text(
          "Sheba 24/7",
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Are you ready to report? If you post fake report, you will end up with severe punishment.",
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "No",
            ),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(
              "Yes",
            ),
            onPressed: () => _createPost(),
          )
        ],
      ),
    );
  }

  _createPost() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("Details $_postDetails");
      try {
        FirebaseUser user = (await FirebaseAuth.instance.currentUser());
        final uid = user.uid;
        Firestore.instance
            .collection("Issues")
            .document()
            .setData(PostModel(_title, _postDetails, uid).toJson())
            .catchError((e) {
          debugPrint(e.toString());
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } catch (e) {
        print(e.message);
      }
    }
  }

  String validateTitle(String value) {
    if ((value.length >= 20) && (value.length <= 40)) {
      return null;
    } else {
      return value.length < 20 ? "Title too small" : "Make your title short";
    }
  }

  String validateDescription(String value) {
    if (value.length >= 20) {
      return null;
    } else {
      return "Description needs to be bigger";
    }
  }
}
