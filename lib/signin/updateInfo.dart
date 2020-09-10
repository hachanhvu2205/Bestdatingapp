import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Bestdatingapp/main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:Bestdatingapp/chat/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateInfoPage extends StatefulWidget {
  @override
  _UpdateInfoPageState createState() => _UpdateInfoPageState();
}

class _UpdateInfoPageState extends State<UpdateInfoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var genderValue = -1;
  var likeValue = -1;
  var gender;
  File _image;
  String _uploadFireUrl, interestedIn;
  final picker = ImagePicker();
  DocumentSnapshot _currentDocument;
  Position position;
  Timestamp birthday;
  GeoPoint location;

  _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    location = GeoPoint(position.latitude, position.longitude);
  }

  getImage(ImageSource source) async {
    PickedFile image = await picker.getImage(source: source);
    setState(() {
      _image = File(image.path);
    });
    uploadPic();
  }

  Future uploadPic() async {
    String fileName = 'images/${DateTime.now()}.png';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    await uploadTask.onComplete;
    firebaseStorageRef.getDownloadURL().then((fileUrl) {
      setState(() {
        _uploadFireUrl = fileUrl;
      });
    });
  }

  getGender(genderValue) {
    if (genderValue == 0) {
      return 'Male';
    } else if (genderValue == 1) {
      return 'Female';
    }
  }

  getInteretedIn(likeValue) {
    if (likeValue == 0) {
      return 'Male';
    } else if (likeValue == 1) {
      return 'Female';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                },
                child: imageSetting(),
              ),
              // update name
              nameSetting(context),

              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime.now().subtract(Duration(days: 6939)),
                    onConfirm: (date) {
                      setState(() {
                        birthday = Timestamp.fromDate(date);
                      });
                    },
                  );
                },
                child: Container(
                  child: Text(
                    "Click to Enter Birthday",
                    style: TextStyle(
                      color: Colors.red[300],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              genderSetting(context),
              interestedInSetting(context),
              submitSetting(context),
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton submitSetting(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        var userId = await databaseMethods.getid();
        var data = {
          "userName": nameController.text,
          "userAge": birthday,
          "userGender": gender,
          "userId": userId,
          'max_distance': 300,
          'max_age': 27,
          'min_age': 18,
          "location": location,
          "image": _uploadFireUrl,
          "interestedIn": interestedIn,
        };
        databaseMethods.update(data);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Main()),
        );
      },
      child: Text('Submit'),
    );
  }

  Container genderSetting(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Column(
        children: <Widget>[
          Text(
            'Choose gender',
            style: TextStyle(color: Colors.red[300]),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: genderValue,
                onChanged: (value) {
                  setState(() {
                    genderValue = value;
                    getGender(genderValue);
                    gender = getGender(genderValue);
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
                    gender = getGender(genderValue);
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

  Container interestedInSetting(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Column(
        children: <Widget>[
          Text(
            'Interested In',
            style: TextStyle(color: Colors.red[300]),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 0,
                groupValue: likeValue,
                onChanged: (value) {
                  setState(() {
                    likeValue = value;
                    getInteretedIn(likeValue);
                    interestedIn = getInteretedIn(likeValue);
                  });
                },
              ),
              Text('Male'),
              Radio(
                value: 1,
                groupValue: likeValue,
                onChanged: (value) {
                  setState(() {
                    likeValue = value;
                    getInteretedIn(likeValue);
                    interestedIn = getInteretedIn(likeValue);
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container imageSetting() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Center(
        child: Stack(
          children: [
            ClipOval(
              child: Container(
                  height: 100,
                  width: 100,
                  child: _image == null
                      ? Image.asset(
                          'assets/asset-1.jpg',
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          _uploadFireUrl,
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
    );
  }
}
