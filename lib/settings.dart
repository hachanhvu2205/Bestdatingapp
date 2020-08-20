import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var selectedAgeRange = RangeValues(18.0, 23.0);
  var value = 0.0;
  var genderValue = -1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      Text('${value.floor()} Km'),
                      Slider(
                        value: value,
                        onChanged: (newValue) {
                          setState(() {
                            value = newValue;
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
                          });
                        },
                        min: 18.0,
                        max: 30.0,
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
                        'Gender',
                        style: TextStyle(color: Colors.red[300]),
                      ),
                      Row(
                        children: <Widget>[
                          Radio(
                            value: 0,
                            groupValue: genderValue,
                            onChanged: (value) {
                              setState(() {
                                genderValue = value;
                              });
                              
                            },
                          ),
                          Text('Male'),
                          Radio(
                            value: 1,
                            groupValue: genderValue,
                            onChanged: (value) {
                              setState(() {
                                genderValue = value;
                              });
                              
                            },
                          ),
                          Text('Female'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
