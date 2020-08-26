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

  getDistance(Position position1, Position position2) async {
    double distance;
    return distance = await Geolocator().distanceBetween(position1.latitude,
        position1.longitude, position2.latitude, position2.longitude);
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
