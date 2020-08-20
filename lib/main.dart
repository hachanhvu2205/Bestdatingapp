import 'package:Bestdatingapp/chat.dart';
import 'package:Bestdatingapp/login.dart';
import 'package:Bestdatingapp/messsage.dart';
import 'package:Bestdatingapp/profile.dart';
import 'package:Bestdatingapp/swipe.dart';
import 'package:Bestdatingapp/updateInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LogInPage(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return buildSwipePage(context);
  }

  DefaultTabController buildSwipePage(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(color: Colors.red[300]),
              child: TabBar(
                tabs: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Tab(
                      icon: Icon(FontAwesomeIcons.fire),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Tab(
                      icon: Icon(FontAwesomeIcons.speakap),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Tab(
                      icon: Icon(FontAwesomeIcons.portrait),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  SwipePage(),
                  MessagePage(),
                  SettingPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
