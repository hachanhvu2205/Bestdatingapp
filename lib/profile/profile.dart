import 'package:Bestdatingapp/profile/addMedia.dart';
import 'package:Bestdatingapp/profile/info.dart';
import 'package:Bestdatingapp/profile/settings.dart';
import 'package:Bestdatingapp/user.dart';
import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bestdatingapp/signin/updateInfo.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  Timestamp age;
  String photoUrl;
  User currentUser;

  void getInfo() async {
    var user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: user.email)
        .getDocuments()
        .then((value) {
      setState(() {
        name = value.documents[0].data["userName"];
        age = value.documents[0].data['userAge'];
        photoUrl = value.documents[0].data['image'];
      });
    });

    print('name: ${name}');
  }

  Future<String> getid() async {
    final user = await FirebaseAuth.instance.currentUser();
    var idDoc = await Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: user.email)
        .getDocuments()
        .then((value) => value.documents[0].documentID);
    return (idDoc);
  }

  getCurrentUserData() async {
    String email;
    await FirebaseAuth.instance.currentUser().then((value) {
      email = value.email;
    });
    String idDoc = await getid();
    await Firestore.instance
        .collection('users')
        .document(idDoc)
        .get()
        .then((value) {
      var info = value.data;
      currentUser = User.fromJson(info);
    });
  }

  @override
  void initState() {
    getInfo();
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[300],
            ),
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          photoUrl == null
                              ? Container()
                              : ClipOval(
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Center(
                                      child: FadeInImage.assetNetwork(
                                        image: photoUrl,
                                        placeholder: 'assets/icon-2.png',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                          age == null
                              ? Container()
                              : Text(
                                  name +
                                      "," +
                                      (DateTime.now().year - age.toDate().year)
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: <Widget>[
                                  ClipOval(
                                    child: GestureDetector(
                                      onTap: () async {
                                        var resp = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SettingsPage(
                                              currentUser: currentUser,
                                            ),
                                          ),
                                        );
                                        if (resp == true) {
                                          getInfo();
                                          getCurrentUserData();
                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.grey[300],
                                        child: Icon(FontAwesomeIcons.cog),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('SETTINGS'),
                                ],
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MediaPage(),
                                              ));
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            height: 75,
                                            width: 75,
                                            color: Colors.red[300],
                                            child: Icon(
                                              FontAwesomeIcons.camera,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: ClipOval(
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            color: Colors.white,
                                            child: Icon(FontAwesomeIcons.plus),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('ADD MEDIA')
                                ],
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: <Widget>[
                                  ClipOval(
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InfoPage())),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.grey[300],
                                        child: Icon(FontAwesomeIcons.pen),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('EDIT INFO'),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
