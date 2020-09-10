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
  double difference;
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
          listUserToView.length == 0
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No user to show',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                )
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
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(children: [
                                    Text(
                                      '${listUserToView[index].name}' +
                                          ',' +
                                          '${getAge(listUserToView[index].age)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        (difference / 1000).toStringAsFixed(2) +
                                            "km away",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    },
                    cardController: cardController,
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) async {
                      /// Get swiping card's alignment
                      if (align.x < 0) {
                        // setState(() {
                        //   listUserToView.removeAt(currentIndex);
                        // });
                      } else if (align.x > 0) {
                        // setState(() {
                        //   listUserToView.removeAt(currentIndex);
                        // });
                        await databaseMethods.chooseUser(
                            currentUser.uid,
                            listUserToView[currentIndex].uid,
                            currentUser.name,
                            currentUser.photo);
                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      /// Get orientation & index of swiped card!
                    },
                  ),
                ),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              iconWidget(Icons.clear, () {
                cardController.triggerLeft();
              }, Colors.blue),
              iconWidget(FontAwesomeIcons.solidHeart, () async {
                cardController.triggerRight();
                await databaseMethods.chooseUser(
                    currentUser.uid,
                    listUserToView[currentIndex].uid,
                    currentUser.name,
                    currentUser.photo);
              }, Colors.red),
            ],
          ),
          SizedBox(
            height: 20,
          )
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

    difference = distance;

    return distance;
  }

  getListUser() async {
    await Firestore.instance.collection('users').getDocuments().then((value) {
      value.documents.forEach((element) {
        User newUser = User.fromJson(element.data);
        listAllUser.add(newUser);
      });
    });
    await filterUserToView(listAllUser);
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
        if (distance <= currentUser.maxDistance * 1000) {
          if (oponentAge >= currentUser.minAge &&
              oponentAge <= currentUser.maxAge) {
            if (!(element.uid == currentUser.uid)) {
              listUserToView.add(element);
            }
          }
        }
      }
    });
    setState(() {});
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

  Widget iconWidget(IconData icon, Function onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.blue),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, color: Colors.grey, offset: Offset(0, 5))
            ]),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
