import 'package:Bestdatingapp/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Bestdatingapp/chat/listlike.dart';
import 'package:photo_view/photo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Bestdatingapp/chat/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Bestdatingapp/chat/database.dart';
import 'package:Bestdatingapp/chat/const.dart';

class ChatPage extends StatefulWidget {
  final User opponent;
  ChatPage({this.opponent});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  Stream<QuerySnapshot> chats;
  User currentUser;
  ScrollController chatScrollController = ScrollController();

  FocusNode chatNode = FocusNode();

  @override
  void initState() {
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => chatScrollController.jumpTo(
    //           chatScrollController.position.maxScrollExtent,
    //         ));
    initChatPage();
    super.initState();
  }

  @override
  void dispose() {
    chatNode.dispose();
    chatScrollController.dispose();
    super.dispose();
  }

  void chatScrollListener() {
    if (chatNode.hasFocus || chatNode.hasPrimaryFocus) {
      if (!chatScrollController.position.atEdge) {
        chatScrollController.animateTo(
            chatScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.linear);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.opponent.name),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                // height: MediaQuery.of(context).size.height * 0.8,
                child: chatMessages(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              height: 60,
              child: TextField(
                controller: chatController,
                focusNode: chatNode,
                onTap: () {
                  if (chatScrollController.position.pixels <
                      chatScrollController.position.minScrollExtent) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      chatScrollController.jumpTo(
                        chatScrollController.position.maxScrollExtent,
                      );
                    });
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      print(chatController.text);
                      addMessage();
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
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List reverseMessages = [];
            reverseMessages.addAll(snapshot.data.documents);
            reverseMessages = reverseMessages.reversed.toList();
            return ListView.builder(
                shrinkWrap: true,
                reverse: true,
                controller: chatScrollController,
                itemCount: reverseMessages.length,
                itemBuilder: (context, index) {
                  return Messagesbubble(
                    message: reverseMessages[index].data["message"],
                    sendByMe: currentUser.name ==
                        reverseMessages[index].data["sendBy"],
                  );
                });
          } else
            return Container();
        });
  }

  getCurrentUserData() async {
    String email;
    await FirebaseAuth.instance.currentUser().then((value) {
      email = value.email;
    });
    String idDoc = await getid();
    await Firestore.instance
        .collection('users')
        .document(idDoc)
        .get()
        .then((value) {
      var info = value.data;
      setState(() {
        currentUser = User.fromJson(info);
      });
    });
  }

  Future<String> getid() async {
    final user = await FirebaseAuth.instance.currentUser();
    var idDoc = await Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: user.email)
        .getDocuments()
        .then((value) => value.documents[0].documentID);
    return (idDoc);
  }

  addMessage() {
    if (chatController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": currentUser.name,
        "message": chatController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods()
          .addMessage(currentUser.uid, widget.opponent.uid, chatMessageMap);

      setState(() {
        chatController.text = "";
      });
    }
  }

  initChatPage() async {
    await getCurrentUserData();
    DatabaseMethods()
        .getChats(currentUser.uid, widget.opponent.uid)
        .then((val) {
      setState(() {
        chats = val;
      });
    });
  }
}

class Messagesbubble extends StatelessWidget {
  final String message;
  final bool sendByMe;

  Messagesbubble({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
