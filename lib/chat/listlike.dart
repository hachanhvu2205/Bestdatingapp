import 'package:Bestdatingapp/chat/chat.dart';
import 'package:flutter/material.dart';

import 'package:Bestdatingapp/chat/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bestdatingapp/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Bestdatingapp/chat/photo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.pink,
          indicatorColor: Colors.pink,
          tabs: [
            Tab(
              icon: Icon(FontAwesomeIcons.heart),
              text: 'Matched Me',
            ),
            Tab(
              icon: Icon(FontAwesomeIcons.thumbsUp),
              text: 'Liked Me',
            ),
          ],
        ),
        body: TabBarView(children: [
          matchedUsers(),
          likedUsers(),
        ]),
      ),
    );
  }

  Widget likedUsers() {
    Size size = MediaQuery.of(context).size;
    return currentUser == null
        ? Container()
        : currentUser.uid == null
            ? Container()
            : StreamBuilder<QuerySnapshot>(
                stream: databaseMethods.getSelectedList(currentUser.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.data.documents != null) {
                    final user = snapshot.data.documents;
                    return Container(
                      child: GridView.builder(
                        itemCount: user.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await databaseMethods
                                  .getUserDetails(user[index].documentID);
                              getDifference(
                                  currentUser.location, selectedUser.location);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: profileWidget(
                                    photo: selectedUser.photo,
                                    photoHeight: size.height * 0.6,
                                    padding: size.height * 0.01,
                                    photoWidth: size.width,
                                    clipRadius: size.height * 0.01,
                                    containerWidth: size.width,
                                    containerHeight: size.height * 0.25,
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
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Text(
                                                            selectedUser.name +
                                                                ", " +
                                                                (DateTime.now()
                                                                            .year -
                                                                        selectedUser
                                                                            .age
                                                                            .toDate()
                                                                            .year)
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    size.height *
                                                                        0.05),
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
                                                          (difference / 1000)
                                                                  .toStringAsFixed(
                                                                      2) +
                                                              " km away",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.height * 0.02,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        iconWidget(Icons.clear,
                                                            () {
                                                          databaseMethods
                                                              .deleteUser(
                                                                  currentUser
                                                                      .uid,
                                                                  selectedUser
                                                                      .uid);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }, Colors.blue),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.2,
                                                        ),
                                                        iconWidget(
                                                            FontAwesomeIcons
                                                                .solidHeart,
                                                            () {
                                                          databaseMethods
                                                              .selectUser(
                                                                  currentUser
                                                                      .uid,
                                                                  selectedUser
                                                                      .uid,
                                                                  currentUser
                                                                      .name,
                                                                  currentUser
                                                                      .photo,
                                                                  selectedUser
                                                                      .name,
                                                                  selectedUser
                                                                      .photo);
                                                          Navigator.of(context)
                                                              .pop();
                                                        }, Colors.red),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: profileWidget(
                              padding: size.height * 0.01,
                              photo: user[index].data['image'],
                              photoWidth: size.width * 0.5,
                              photoHeight: size.height * 0.3,
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.03,
                              containerWidth: size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  user[index].data['userName'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
  }

  Widget matchedUsers() {
    Size size = MediaQuery.of(context).size;
    return currentUser == null
        ? Container()
        : currentUser.uid == null
            ? Container()
            : StreamBuilder<QuerySnapshot>(
                stream: databaseMethods.getMatchedList(currentUser.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.data.documents != null) {
                    final user = snapshot.data.documents;
                    return GridView.builder(
                      itemCount: user.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            User selectedUser = await databaseMethods
                                .getUserDetails(user[index].documentID);
                            getDifference(
                                currentUser.location, selectedUser.location);

                            // databaseMethods.openChat(
                            //     currentUser.uid, selectedUser.uid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          opponent: selectedUser,
                                        )));
                          },
                          child: profileWidget(
                            padding: size.height * 0.01,
                            photo: user[index].data['image'],
                            photoWidth: size.width * 0.5,
                            photoHeight: size.height * 0.5,
                            clipRadius: size.height * 0.01,
                            containerHeight: size.height * 0.03,
                            containerWidth: size.width * 0.5,
                            child: Text(
                              "  " + user[index].data['userName'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
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
    setState(() {});
  }

  Widget iconWidget(icon, onTap, color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          icon,
          color: color,
        ),
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
            photo == null
                ? Container()
                : Container(
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
