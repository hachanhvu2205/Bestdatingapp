import 'package:flutter/material.dart';
import 'package:Bestdatingapp/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';

class UpdateInfoPage extends StatefulWidget {
  @override
  _UpdateInfoPageState createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  var genderValue = -1;
  var gender;
  File _image;
  final picker = ImagePicker();
  Position position;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  getGender(genderValue) {
    if (genderValue == 0) {
      return 'Male';
    } else if (genderValue == 1) {
      return 'Female';
    }
  }

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
  void initState() {
    // TODO: implement initState
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                getImage();
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/asset-1.jpg'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipOval(
                          child: Container(
                            width: 25,
                            height: 25,
                            color: Colors.white,
                            child: Icon(FontAwesomeIcons.plus),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // update name
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Column(
                children: <Widget>[
                  Text(
                    'Add name',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  Form(
                    child: TextFormField(
                      controller: nameController,
                      onFieldSubmitted: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Name...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Column(
                children: <Widget>[
                  Text(
                    'Add age',
                    style: TextStyle(color: Colors.red[300]),
                  ),
                  Form(
                    child: TextFormField(
                      controller: ageController,
                      onFieldSubmitted: (value) {},
                      decoration: InputDecoration(
                        hintText: 'Age...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Column(
                children: <Widget>[
                  Text(
                    'Choose gender',
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
                            getGender(genderValue);
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
                            getGender(genderValue);
                          });
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                ],
              ),
            ),

            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Main()),
                );
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
