import 'dart:io';

import 'package:bracu_tracthon/screens/login.dart';
import 'package:bracu_tracthon/screens/post_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser mFirebaseUser;

  const MainPage({Key key, this.mFirebaseUser}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () => exit(0),
          ),
          elevation: 0,
          bottom: TabBar(
            tabs: <Widget>[
              buildTab("Report", Icons.report),
              buildTab("Emergency", Icons.phone),
              buildTab("Account", Icons.account_circle),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ReportPage(),
            _reportView(),
            AccountProfilePage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _reportView() {
    return Container(
      child: InkWell(
        child: Text("Hello"),
        onTap: () => logOutPopDialogue(),
      ),
    );
  }

  Tab buildTab(String tabName, IconData iconData) {
    return Tab(
      child: Column(
        children: <Widget>[
          Icon(iconData),
          Text(tabName),
        ],
      ),
    );
  }

  logOutPopDialogue() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        title: Text(
          "Kiree",
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Do you really want to log out?",
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
            onPressed: () => logOut(),
          )
        ],
      ),
    );
  }

  logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

class AccountProfilePage extends StatefulWidget {
  @override
  _AccountProfilePageState createState() => _AccountProfilePageState();
}

class _AccountProfilePageState extends State<AccountProfilePage> {

  Text input;

  _AccountProfilePageState() {
    inputText().then((onValue)=> setState((){
      input = onValue;
    }));
  }
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
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
              onPressed: () => fetchData(),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            buttonColor: Colors.blue,
          ),
        ),
        Container(
          child: input,
        ),
      ],
    );
  }

  Future<Widget> inputText () async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    final DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Users").document(uid).get();
    final list = documentSnapshot.data;
    return Text("${list["first_name"]}");
  }

  fetchData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final uid = user.uid;
    final DocumentSnapshot documentSnapshot = await Firestore.instance.collection("Users").document(uid).get();
    final list = documentSnapshot.data;

    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        color: Color(0xff737373),
        height: 350,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )
          ),
          child: buildDetails(list),
        ),
      );
    });

  }

  Column buildDetails(Map<String, dynamic> list) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("List value name ${list["first_name"]}"),
      ],
    );
  }
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  var screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Reports",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("Issues")
                  .orderBy("time")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(" Error... Something went wrong ");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(
                    child: SpinKitRing(color: Colors.blue),
                  );
                } else {
                  final list = (snapshot.data.documents).reversed.toList();

                  return ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      color: Colors.blue,
                      axisDirection: AxisDirection.down,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return reportCards(list, index);
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget reportCards(List l, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostViewPage(
                title: l[index]["title"],
                postDetails: l[index]["report"],
                isSolved: l[index]["solved"],
              ),
            ),
          )
        },
        child: Center(
          child: Container(
            height: screenHeight * 0.2,
            width: screenWidth * 0.9,
            child: Material(
              elevation: 7,
              color: l[index]["solved"] ? Colors.green : Colors.orange,
              borderOnForeground: true,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Tile: ${l[index]["title"]}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            l[index]["solved"] ? "Solved" : "Not solved",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
