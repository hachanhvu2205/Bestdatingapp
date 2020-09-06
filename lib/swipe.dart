import 'dart:ui';

import 'package:Bestdatingapp/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:Bestdatingapp/chat/database.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  var controller;
  bool isLiked = false;
  bool isNope = false;
  int currentIndex;
  User user, currentUser;
  int difference;
  User opponent;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  CardController cardController = CardController();
  List<User> listUserToView = [];
  List<User> listAllUser = [];

  @override
  void initState() {
    getCurrentUserData();
    getListUser();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(listUserToView.length);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          listAllUser.length == 0
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: TinderSwapCard(
                    swipeUp: false,
                    swipeDown: false,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: listUserToView.length,
                    stackNum: 3,
                    swipeEdge: 4.0,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                    cardBuilder: (context, index) {
                      currentIndex = index;
                      getDifference(
                          currentUser.location, listUserToView[index].location);
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 500,
                              height: 500,
                              child: Card(
                                child: Image.network(
                                  '${listUserToView[index].photo}',
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                " " +
                                    '${listUserToView[index].name}' +
                                    ',' +
                                    '${getAge(listUserToView[index].age)}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                Text(
                                  (difference / 1000).floor().toString() +
                                      "km away",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                iconWidget(
                                    EvaIcons.flash, () {}, Colors.yellow),
                                iconWidget(Icons.clear, () {
                                  cardController.triggerLeft();
                                }, Colors.blue),
                                iconWidget(FontAwesomeIcons.solidHeart, () {
                                  cardController.triggerRight();
                                  databaseMethods.chooseUser(
                                      currentUser.uid,
                                      listUserToView[index].uid,
                                      currentUser.name,
                                      currentUser.photo);
                                }, Colors.red),
                                iconWidget(
                                    EvaIcons.options2, () {}, Colors.white)
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    cardController: cardController,
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {
                      /// Get swiping card's alignment
                      if (align.x < 0) {
                        //Card is LEFT swiping
                      } else if (align.x > 0) {
                        //Card is RIGHT swiping
                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      /// Get orientation & index of swiped card!
                    },
                  ),
                ),
        ],
      ),
    );
  }

  getDifference(GeoPoint userLocation, GeoPoint oponentLocation) async {
    double distance = await Geolocator().distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        oponentLocation.latitude,
        oponentLocation.longitude);
    difference = distance.toInt();
  }

  getListUser() async {
    await Firestore.instance.collection('users').getDocuments().then((value) {
      value.documents.forEach((element) {
        User newUser = User.fromJson(element.data);
        listAllUser.add(newUser);
      });
    });
    filterUserToView(listAllUser);
  }

  getAge(Timestamp birthDate) {
    int age = DateTime.now().year - birthDate.toDate().year;
    return age;
  }

  filterUserToView(List<User> listAllUser) async {
    String email;
    var tempUser;
    await FirebaseAuth.instance.currentUser().then((value) {
      email = value.email;
    });
    String idDoc = await getid();
    await Firestore.instance
        .collection('users')
        .document(idDoc)
        .get()
        .then((value) {
      tempUser = value.data;
    });

    User currentUser = User.fromJson(tempUser);
    listAllUser.forEach((element) async {
      double distance =
          await getDifference(currentUser.location, element.location);
      int oponentAge = getAge(element.age);
      if (element.gender == currentUser.interestedIn) {
        if (distance <= currentUser.maxDistance) {
          if (oponentAge >= currentUser.minAge &&
              oponentAge <= currentUser.maxAge) {
            setState(() {
              listUserToView.add(element);
            });
          } else
            return Text(
              "No One Here",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            );
        } else
          return Text(
            "No One Here",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          );
      } else
        return Text(
          "No One Here",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        );
    });
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
}
