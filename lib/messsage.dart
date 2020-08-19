import 'package:Bestdatingapp/chat.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  User currentUser = new User(
    id: '1',
    name: 'Tung',
    age: 19,
    idLiked: ['2', '3'],
  );
  List<User> matchedUsers = [
    User(
      id: '1',
      name: 'Tung',
      age: 19,
      idLiked: ['2', '3'],
    ),
    User(
      id: '2',
      name: 'Ngoc',
      age: 20,
      idLiked: ['3'],
    ),
    User(
      id: '3',
      name: 'Hoa',
      age: 20,
      idLiked: ['1'],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  height: 100,
                  width: 400,
                  decoration: BoxDecoration(color: Colors.red[300], borderRadius: BorderRadius.circular(16),),
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Text('${matchedUsers[index].name}'),
                        Text('${matchedUsers[index].age}'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: matchedUsers.length,
    );
  }
}

class User {
  String id;
  int age;
  String bio;
  String name;
  List<String> idLiked;
  User({this.id, this.age, this.bio, this.name, this.idLiked});
}
