import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    int genderValue = -1;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Infos'),
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Align(
            child: Container(
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Change bio',
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        Form(
                          child: TextFormField(
                            controller: bioController,
                            onFieldSubmitted: (value) {
                              print(bioController.text);
                            },
                            decoration: InputDecoration(
                              hintText: 'Bio...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Change name',
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        Form(
                          child: TextFormField(
                            controller: nameController,
                            onFieldSubmitted: (value) {
                              print(bioController.text);
                            },
                            decoration: InputDecoration(
                              hintText: 'Name...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Change age',
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        Form(
                          child: Container(
                            child: TextFormField(
                              controller: ageController,
                              onFieldSubmitted: (value) {
                                print(bioController.text);
                              },
                              decoration: InputDecoration(
                                hintText: 'Age...',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Change gender',
                          style: TextStyle(color: Colors.red[300]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            SizedBox(
                              width: 100,
                            ),
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
      ),
    );
  }
}
