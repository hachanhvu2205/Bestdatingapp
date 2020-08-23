import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoPosition extends StatefulWidget {
  @override
  _GeoPositionState createState() => _GeoPositionState();
}

class _GeoPositionState extends State<GeoPosition> {
  Position position;

  getPosition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          getPosition();
        },
      ),
    );
  }
}
