import 'package:Bestdatingapp/chat.dart';
import 'package:Bestdatingapp/login.dart';
import 'package:Bestdatingapp/messsage.dart';
import 'package:Bestdatingapp/setting.dart';
import 'package:Bestdatingapp/swipe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(),
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
              decoration: BoxDecoration(color: Colors.blue),
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
