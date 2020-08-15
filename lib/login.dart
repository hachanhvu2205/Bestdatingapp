import 'package:Bestdatingapp/signup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
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
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                ),
              ),
            ),
            Row(
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
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 16, 40, 20),
              child: RaisedButton(
                onPressed: () {},
                color: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Text(
              'Or login with',
              textAlign: TextAlign.center,
            ),
            Expanded(
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
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black)),
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
            ),
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
}
