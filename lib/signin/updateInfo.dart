import 'package:Bestdatingapp/signin/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Bestdatingapp/main.dart';
import 'package:flutter/services.dart';
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

  getImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
    uploadPic();
  }

  Future uploadPic() async {
    String fileName = 'images/${DateTime.now()}.png';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
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
    print(position.latitude);
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
                getImage(ImageSource.gallery);
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
                            child: Image.asset(
                              'assets/asset-1.jpg',
                              fit: BoxFit.fill,
                            )),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: ClipOval(
                          child: Container(
                            width: 25,
                            height: 25,
                            color: Colors.white,
                            child: Icon(FontAwesomeIcons.camera),
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
                  SizedBox(
                    height: 15,
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
                  SizedBox(
                    height: 15,
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
                  MaterialPageRoute(builder: (context) => LogInPage()),
                );
              },
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Container nameSetting(BuildContext context) {
    return Container(
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container ageSetting(BuildContext context) {
    return Container(
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container genderSetting(BuildContext context) {
    return Container(
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
    );
  }

  Container image(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Column(
        children: <Widget>[
          Text(
            'Add image',
            style: TextStyle(color: Colors.red[300]),
          ),
          Form(
            child: TextFormField(
              controller: imageController,
              onFieldSubmitted: (value) {},
              decoration: InputDecoration(
                hintText: 'Image...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
