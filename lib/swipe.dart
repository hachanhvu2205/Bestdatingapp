import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  var controller;
  bool isLiked = false;
  int currentIndex;
  static Position position;
  static getPosition() async {
    return position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
  }

  User currentUser = new User(
      id: '12345', age: 19, bio: 'bio', name: 'Tung', idLiked: ['2', '3']);
  List<Profile> profiles = [
    Profile(
      photos: 'assets/asset-3.jpg',
      name: 'Tung',
      bio: 'sugar bb pls',
    ),
    Profile(
      photos: 'assets/asset-2.jpg',
      name: 'Bich',
      bio: 'my bio',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: TinderSwapCard(
              swipeUp: false,
              swipeDown: false,
              orientation: AmassOrientation.BOTTOM,
              totalNum: profiles.length,
              stackNum: 3,
              swipeEdge: 4.0,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 0.9,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              cardBuilder: (context, index) {
                currentIndex = index;
                return Stack(
                  children: <Widget>[
                    Container(
                      width: 500,
                      height: 500,
                      child: Card(
                        child: Image.asset(
                          '${profiles[index].photos}',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '${profiles[index].name}\n${profiles[index].bio}}',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    )
                  ],
                );
              },
              cardController: controller = CardController(),
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
          IconButton(
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                  if (isLiked == true) {
                    if (!currentUser.idLiked
                        .contains('${profiles[currentIndex].name}')) {
                      currentUser.idLiked.add('${profiles[currentIndex].name}');
                    }
                  }
                });
              },
              icon: Icon(FontAwesomeIcons.solidHeart),
              color: isLiked ? Colors.red : Colors.black)
        ],
      ),
    );
  }
}

class Profile {
  final String photos;
  final String name;
  final String bio;
  Position location;
  Profile({this.photos, this.name, this.bio, this.location});
}

class User {
  String id;
  int age;
  String bio;
  String name;
  List<String> idLiked;
  Position location;
  User({this.id, this.age, this.bio, this.name, this.idLiked, this.location});
}
