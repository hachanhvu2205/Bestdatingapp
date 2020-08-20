import 'package:Bestdatingapp/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Bestdatingapp/service.dart';
import 'package:Bestdatingapp/login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _auth = AuthService();

  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('Already a member? Log in'),
            )
          ],
        ),
      ),
    );
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

  Container register() {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 16, 40, 20),
      child: RaisedButton(
        onPressed: validationAndRegister,
        color: Colors.purple,
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
        validator: (value) {
          value.isEmpty ? 'Password must not be empty' : null;

          // Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{8,}$';
          // RegExp regex = new RegExp(pattern);
          // if (!regex.hasMatch(value))
          //   return 'Invalid password';
          // else
          //   return null;
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
        FirebaseUser user = await AuthService.signUp(_email, _password);
        if (user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LogInPage(),),);
        }
      } catch (e) {
        print('$e');
      }
    }
  }
}
