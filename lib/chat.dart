import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Bestdatingapp/messsage.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  List<Message> messages = [
    Message(
        content: '11111111111111111111111111111111111111111111111111',
        id: '1',
        name: 'Tung'),
    Message(
        content: '111111111111111111111111111111111111111111111',
        id: '2',
        name: 'Ngoc')
  ];
  User currentUser = new User(
    id: '1',
    name: 'Tung',
    age: 19,
    idLiked: ['2', '3'],
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    chatController.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: messages[index].id == currentUser.id
                          ? buildRightMessage(index)
                          : buildLeftMessage(index),
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: chatController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        print(chatController.text);
                      },
                      child: Icon(FontAwesomeIcons.paperPlane),
                    ),
                    hintText: 'Type...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLeftMessage(int index) => Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          children: <Widget>[
            Text('${messages[index].name}'),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Align(
                child: Text('${messages[index].content}'),
              ),
            ),
          ],
        ),
      );

  Widget buildRightMessage(int index) => Align(
        alignment: Alignment.bottomRight,
        child: Column(
          children: <Widget>[
            Text('${messages[index].name}'),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width * 0.5),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Align(
                child: Text(
                  '${messages[index].content}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );

  Widget createBubble(String text) {
    return null;
  }
}

class Message {
  String content;
  String id;
  String name;
  Message({this.content, this.id, this.name});
}
