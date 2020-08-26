import 'package:Bestdatingapp/main.dart';
import 'package:Bestdatingapp/signin/signup.dart';
import 'package:Bestdatingapp/signin/updateInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Bestdatingapp/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bestdatingapp/chat/database.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formKey = new GlobalKey<FormState>();
  AuthService authService = new AuthService();
  String _email;
  String _password;
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  email(),
                  password(),
                  rememberMe(),
                  login(),
                ],
              ),
            ),
            Text(
              'Or login with',
              textAlign: TextAlign.center,
            ),
            socialMedia(),
            InkWell(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                )
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('Not a member? Sign up now'),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validation() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validationAndSubmit() async {
    if (validation()) {
      await authService
          .signInWithEmailAndPassword(_email, _password)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(_email);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Main()),
          );
        }
      });
    }
  }

  Expanded socialMedia() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: FlatButton(
              onPressed: () {},
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey, width: 1)),
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.google),
                  
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: FlatButton(
              onPressed: () {},
              color: Colors.white,
              shape:
                  RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
              child: Row(
                children: <Widget>[
                  Icon(FontAwesomeIcons.facebook)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container login() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 16, 40, 20),
      child: RaisedButton(
        onPressed: validationAndSubmit,
        color: Colors.red[300],
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Row rememberMe() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Checkbox(
            activeColor: Colors.purple,
            value: value,
            onChanged: (bool newValue) {
              setState(() {
                value = newValue;
              });
            },
          ),
        ),
        Text(
          'Remember me',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Container password() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: TextFormField(
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password must be filled' : null,
        onSaved: (value) => _password = value,
        decoration: InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          prefixIcon: Icon(
            Icons.lock,
          ),
        ),
      ),
    );
  }

  Container email() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: TextFormField(
        validator: (value) => value.isEmpty ? 'Email must be filled' : null,
        onSaved: (value) => _email = value,
        decoration: InputDecoration(
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          prefixIcon: Icon(
            Icons.email,
          ),
        ),
      ),
    );
  }
}
