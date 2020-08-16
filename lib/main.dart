import 'package:Bestdatingapp/login.dart';
import 'package:Bestdatingapp/swipe.dart';
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
        primarySwatch: Colors.blue,
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
    return DefaultTabController(
      length: 4,
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
                      icon: Icon(FontAwesomeIcons.starOfLife),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Tab(
                      icon: Icon(FontAwesomeIcons.fire),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Tab(
                      icon: Icon(FontAwesomeIcons.fire),
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
                  Text('data'),
                  Text('data'),
                  Text('data'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
