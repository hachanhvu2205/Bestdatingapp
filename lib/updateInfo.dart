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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          // update name
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Colors.white,
            width: MediaQuery.of(context).size.width * 0.8,
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
            width: MediaQuery.of(context).size.width * 0.8,
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
            width: MediaQuery.of(context).size.width * 0.8,
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  'Add image link',
                  style: TextStyle(color: Colors.red[300]),
                ),
                Form(
                  child: TextFormField(
                    controller: imageController,
                    onFieldSubmitted: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Image...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Main()),);
            },
            child: Text('Submit'),
          )
        ],
      )),
    );
  }
}
