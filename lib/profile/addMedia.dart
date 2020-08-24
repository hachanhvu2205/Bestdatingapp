import 'package:flutter/material.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                color: Colors.red,
                height: 100,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
