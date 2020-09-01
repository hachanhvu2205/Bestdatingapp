import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Bestdatingapp/user.dart';

class DatabaseMethods {
  Future<String> getid() async {
    final user = await FirebaseAuth.instance.currentUser();
    var idDoc = await Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: user.email)
        .getDocuments()
        .then((value) => value.documents[0].documentID);
    return (idDoc);
  }

  Future<void> addUserInfo(userData) async {
    Firestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> update(Map data) async {
    final user = await FirebaseAuth.instance.currentUser();
    print('day la user uid cua ${user.email}: ');
    var idDoc = await Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: user.email)
        .getDocuments()
        .then((value) => value.documents[0].documentID);

    Firestore.instance.collection("users").document(idDoc).updateData(data);
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  Future<User> chooseUser(currentUserId, selectedUserId, name, photoUrl) async {
    await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    await Firestore.instance
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await Firestore.instance
        .collection('users')
        .document(selectedUserId)
        .collection('selectedList')
        .document(currentUserId)
        .setData({
      'userName': name,
      'image': photoUrl,
    });
    return getUser(currentUserId);
  }

  Future<User> getUser(userId) async {
    User _user = User();
    List<String> chosenList = await getChosenList(userId);
    User currentUser = await getUserInterests(userId);

    await Firestore.instance.collection('users').getDocuments().then((users) {
      for (var user in users.documents) {
        if ((!chosenList.contains(user.documentID)) &&
            (user.documentID != userId) &&
            (currentUser.interestedIn == user['gender']) &&
            (user['interestedIn'] == currentUser.gender)) {
          _user.uid = user.documentID;
          _user.name = user['userName'];
          _user.photo = user['image'];
          _user.age = user['userAge'];
          _user.location = user['location'];
          _user.gender = user['userGender'];
          _user.interestedIn = user['interested in'];
          break;
        }
      }
    });

    return _user;
  }

  passUser(currentUserId, selectedUserId) async {
    await Firestore.instance
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});
    return getUser(currentUserId);
  }

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('chosenList')
        .getDocuments()
        .then((docs) {
      for (var doc in docs.documents) {
        if (docs.documents != null) {
          chosenList.add(doc.documentID);
        }
      }
    });
    return chosenList;
  }

  Future getUserInterests(userId) async {
    User currentUser = User();

    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
      currentUser.name = user['name'];
      currentUser.photo = user['photoUrl'];
      currentUser.gender = user['gender'];
      currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }
}
