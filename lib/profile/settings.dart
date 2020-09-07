import 'package:Bestdatingapp/profile/profile.dart';
import 'package:Bestdatingapp/service.dart';
import 'package:Bestdatingapp/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Bestdatingapp/chat/database.dart';

class SettingsPage extends StatefulWidget {
  User currentUser;

  SettingsPage({Key key, @required this.currentUser}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var selectedAgeRange;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var value = 0;
  int interestedIn = 0;
  double maxDistance = 0;
  int minAge = 0, maxAge = 0;

  @override
  void initState() {
    minAge = widget.currentUser.minAge;
    maxAge = widget.currentUser.maxAge;
    maxDistance = widget.currentUser.maxDistance.toDouble();
    interestedIn = widget.currentUser.interestedIn == 'Male' ? 0 : 1;
    selectedAgeRange = RangeValues(minAge.toDouble(), maxAge.toDouble());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Align(
          child: Container(
            color: Colors.grey[300],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Maximum Distance',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                      Text('${maxDistance.floor()} Km'),
                      Slider(
                        value: maxDistance,
                        onChanged: (value) {
                          setState(() {
                            maxDistance = value;
                          });
                        },
                        max: 300.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Age',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                      Text(
                          '${selectedAgeRange.start.floor()} - ${selectedAgeRange.end.floor()}'),
                      RangeSlider(
                        values: selectedAgeRange,
                        onChanged: (RangeValues newRange) {
                          setState(() {
                            selectedAgeRange = newRange;
                            minAge = newRange.start.floor();
                            maxAge = newRange.end.floor();
                          });
                        },
                        min: 18.0,
                        max: 50.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Show me\nGender',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: interestedIn,
                            onChanged: (value) {
                              setState(() {
                                interestedIn = value;
                              });
                            },
                          ),
                          Text('Male'),
                          SizedBox(
                            width: 100,
                          ),
                          Radio(
                            value: 1,
                            groupValue: interestedIn,
                            onChanged: (value) {
                              setState(() {
                                interestedIn = value;
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: FlatButton(
                    onPressed: () async {
                      var userId = await databaseMethods.getid();
                      var data = {
                        "min_age": minAge,
                        "max_age": maxAge,
                        "max_distance": maxDistance.floor(),
                        "interestedIn": getGender(interestedIn),
                      };
                      await databaseMethods.update(data);

                      Navigator.pop(context, true);
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getGender(genderValue) {
    if (genderValue == 0) {
      return 'Male';
    } else if (genderValue == 1) {
      return 'Female';
    }
  }
}
