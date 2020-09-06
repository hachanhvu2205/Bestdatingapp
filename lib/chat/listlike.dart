import 'package:Bestdatingapp/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:Bestdatingapp/chat/search.dart';
import 'package:Bestdatingapp/chat/const.dart';
import 'package:Bestdatingapp/chat/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bestdatingapp/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Bestdatingapp/chat/photo.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  int difference;
  User currentUser;
  getDifference(GeoPoint userLocation, GeoPoint oponentLocation) async {
    double distance = await Geolocator().distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        oponentLocation.latitude,
        oponentLocation.longitude);
    difference = distance.toInt();
  }

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    StreamBuilder<QuerySnapshot>(
      stream: databaseMethods.getMatchedList(currentUser.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Container(),
          );
        }
        if (snapshot.data.documents != null) {
          final user = snapshot.data.documents;

          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    User selectedUser = await databaseMethods
                        .getUserDetails(user[index].documentID);
                    getDifference(currentUser.location, selectedUser.location);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: profileWidget(
                          photo: selectedUser.photo,
                          photoHeight: size.height,
                          padding: size.height * 0.01,
                          photoWidth: size.width,
                          clipRadius: size.height * 0.01,
                          containerWidth: size.width,
                          containerHeight: size.height * 0.2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.02),
                            child: ListView(
                              children: <Widget>[
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(selectedUser.gender),
                                    Expanded(
                                      child: Text(
                                        " " +
                                            selectedUser.name +
                                            ", " +
                                            (DateTime.now().year -
                                                    selectedUser.age
                                                        .toDate()
                                                        .year)
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.05),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      difference != null
                                          ? (difference / 1000)
                                                  .floor()
                                                  .toString() +
                                              " km away"
                                          : "away",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.height * 0.02),
                                      child: iconWidget(Icons.message, () {
                                        databaseMethods.openChat(
                                            currentUser.uid, selectedUser.uid);
                                      }, Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: profileWidget(
                    padding: size.height * 0.01,
                    photo: user[index].data['photoUrl'],
                    photoWidth: size.width * 0.5,
                    photoHeight: size.height * 0.3,
                    clipRadius: size.height * 0.01,
                    containerHeight: size.height * 0.03,
                    containerWidth: size.width * 0.5,
                    child: Text(
                      "  " + user[index].data['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              childCount: user.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Container(),
          );
        }
      },
    );
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

  Widget iconWidget(icon, onTap, color) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget profileWidget(
      {padding,
      photoHeight,
      photoWidth,
      clipRadius,
      photo,
      containerHeight,
      containerWidth,
      child}) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: Offset(10.0, 10.0),
            )
          ],
          borderRadius: BorderRadius.circular(clipRadius),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              width: photoWidth,
              height: photoHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(clipRadius),
                child: PhotoWidget(
                  photoLink: photo,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black87,
                    Colors.black
                  ], stops: [
                    0.1,
                    0.2,
                    0.4,
                    0.9
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(clipRadius),
                    bottomRight: Radius.circular(clipRadius),
                  )),
              width: containerWidth,
              height: containerHeight,
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
