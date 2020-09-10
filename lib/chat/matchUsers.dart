import 'package:flutter/material.dart';
import 'package:Bestdatingapp/user.dart';

class MatchUsersPage extends StatefulWidget {
  @override
  _MatchUsersPageState createState() => _MatchUsersPageState();
}

class _MatchUsersPageState extends State<MatchUsersPage> {
  List<User> listMatch = [
    User(
      uid: '1',
    ),
    User(uid: '2'),
  ];

  getData() {}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Container(
            child: Text('No data'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[300]),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return buildList();
        }
      },
    );
  }

  Column buildList() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: listMatch.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                            width: 20,
                            height: 20,
                            child: Image.network('${listMatch[index].photo}')),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${listMatch[index].name}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${listMatch[index].age}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
