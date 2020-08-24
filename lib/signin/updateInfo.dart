import 'package:flutter/material.dart';
import 'package:Bestdatingapp/main.dart';

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
  getGender(genderValue) {
    if (genderValue == 0) {
      return 'Male';
    } else if (genderValue == 1) {
      return 'Female';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // update name
            nameSetting(context),
            ageSetting(context),
            genderSetting(context),
            image(context),
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
