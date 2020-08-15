import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  var controller;

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
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: TinderSwapCard(
            swipeUp: true,
            swipeDown: true,
            orientation: AmassOrientation.BOTTOM,
            totalNum: profiles.length,
            stackNum: 3,
            swipeEdge: 4.0,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.width * 0.9,
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.width * 0.8,
            cardBuilder: (context, index) => Stack(
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
                    '${profiles[index].name}\n${profiles[index].bio}',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                )
              ],
            ),
            cardController: controller = CardController(),
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
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
      ),
    );
  }
}

class Profile {
  final String photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}
