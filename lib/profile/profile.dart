import 'package:Bestdatingapp/profile/addMedia.dart';
import 'package:Bestdatingapp/profile/info.dart';
import 'package:Bestdatingapp/profile/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  int age;

  void getInfo() async {
    var user = await FirebaseAuth.instance.currentUser();
    var userQuery = Firestore.instance
        .collection('Users')
        .where('e-mail', isEqualTo: '$user.email');

    userQuery.getDocuments().then((data) {
      if (data.documents.length > 0) {
        setState(() {
          name = data.documents[0].data['userName'];
          age = data.documents[0].data['userAge'];
        });
      }
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        ClipOval(
                          child: Container(
                            height: 150,
                            width: 150,
                            child: Image.asset('assets/asset-1.jpg'),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(name),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: <Widget>[
                                ClipOval(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingsPage()));
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
                                              builder: (context) => MediaPage(),
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
                                            builder: (context) => InfoPage())),
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
