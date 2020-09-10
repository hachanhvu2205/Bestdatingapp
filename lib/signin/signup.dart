import 'package:Bestdatingapp/main.dart';
import 'package:Bestdatingapp/profile/profile.dart';
import 'package:Bestdatingapp/signin/login.dart';
import 'package:Bestdatingapp/signin/updateInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Bestdatingapp/service.dart';
import 'package:Bestdatingapp/chat/database.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService authService = AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
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
                    confirmPassword(),
                    rememberMe(),
                    register(),
                  ],
                ),
              ),
              Text(
                'Or login with',
                textAlign: TextAlign.center,
              ),
              socialMedia(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInPage()));
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text('Already a member? Log in'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget socialMedia() {
    return Row(
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
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 1)),
            child: Row(
              children: <Widget>[Icon(FontAwesomeIcons.facebook)],
            ),
          ),
        ),
      ],
    );
  }

  Container register() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 16, 40, 20),
      child: RaisedButton(
        onPressed: validationAndRegister,
        color: Colors.red[300],
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Register',
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

  Container confirmPassword() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: TextFormField(
        validator: (value) {
          value.isEmpty ? 'confirm password must not be empty' : null;
          _confirmPassword == _password ? 'Password does not match' : null;
        },
        onSaved: (value) => _confirmPassword = value,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          prefixIcon: Icon(
            Icons.lock,
          ),
        ),
      ),
    );
  }

  Container password() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: TextFormField(
        validator: (val) {
          return val.length < 6 ? "Enter Password 6+ characters" : null;
        },
        onSaved: (value) => _password = value,
        obscureText: true,
        decoration: new InputDecoration(
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
        validator: (value) {
          value.isEmpty ? 'Email must not be empty' : Null;
          validateEmail(value) ? null : "Invalid email address";
        },
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

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validation() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validationAndRegister() async {
    if (validation()) {
      try {
        await authService.signUp(_email, _password).then((value) {
          if (value != null) {
            Map<String, String> userDataMap = {
              "userEmail": _email,
            };
            databaseMethods.addUserInfo(userDataMap);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateInfoPage(),
              ),
            );
          }
        });
      } catch (e) {
        print('$e');
      }
    }
  }
}
