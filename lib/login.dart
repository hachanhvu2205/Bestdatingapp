import 'package:Bestdatingapp/main.dart';
import 'package:Bestdatingapp/signup.dart';
import 'package:Bestdatingapp/updateInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formKey = new GlobalKey<FormState>();
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
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdateInfoPage()),
          );
        }
      } catch (e) {
        print('$e');
      }
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
                  Text(
                    'Google',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
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
                  RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.network(
                      'https://is2-ssl.mzstatic.com/image/thumb/Purple114/v4/24/12/20/2412205b-b0fc-28ba-dd35-992aa9f2b430/Icon-Production-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/246x0w.png',
                      height: 10,
                      width: 10,
                    ),
                  ),
                  Text('Facebook'),
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
        color: Colors.purple,
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
