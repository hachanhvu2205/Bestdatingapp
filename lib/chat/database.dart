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

  Future<Stream<QuerySnapshot>> getChats(
      String currentUserId, String opponentId) async {
    return Firestore.instance
        .collection("users")
        .document(currentUserId)
        .collection("chats")
        .document(opponentId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(
      String userId, String opponentId, Map<String, dynamic> chatMessageData) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("chats")
        .document(opponentId)
        .collection('messages')
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });

    Firestore.instance
        .collection("users")
        .document(opponentId)
        .collection("chats")
        .document(userId)
        .collection('messages')
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
      currentUser.name = user['userName'];
      currentUser.photo = user['image'];
      currentUser.gender = user['userGender'];
      currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }

  Stream<QuerySnapshot> getMatchedList(userId) {
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('matchedList')
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedList(userId) {
    return Firestore.instance
        .collection('users')
        .document(userId)
        .collection('selectedList')
        .snapshots();
  }

  Future<User> getUserDetails(userId) async {
    User _user = User();

    await Firestore.instance
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
      _user.uid = user.documentID;
      _user.name = user['userName'];
      _user.photo = user['image'];
      _user.age = user['userAge'];
      _user.location = user['location'];
      _user.gender = user['userGender'];
      _user.interestedIn = user['interestedIn'];
    });

    return _user;
  }

  // Future openChat(currentUserId, selectedUserId) async {
  //   await Firestore.instance
  //       .collection('users')
  //       .document(currentUserId)
  //       .collection('chats')
  //       .document(selectedUserId)
  //       .collection('messages').add(data)});

  //   await Firestore.instance
  //       .collection('users')
  //       .document(selectedUserId)
  //       .collection('chats')
  //       .document(currentUserId)
  //       .setData({'timestamp': DateTime.now()});

  //   // await Firestore.instance
  //   //     .collection('users')
  //   //     .document(currentUserId)
  //   //     .collection('matchedList')
  //   //     .document(selectedUserId)
  //   //     .delete();

  //   // await Firestore.instance
  //   //     .collection('users')
  //   //     .document(selectedUserId)
  //   //     .collection('matchedList')
  //   //     .document(currentUserId)
  //   //     .delete();
  // }

  void deleteUser(currentUserId, selectedUserId) async {
    return await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('selectedList')
        .document(selectedUserId)
        .delete();
  }

  Future selectUser(currentUserId, selectedUserId, currentUserName,
      currentUserPhotoUrl, selectedUserName, selectedUserPhotoUrl) async {
    deleteUser(currentUserId, selectedUserId);

    await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .collection('matchedList')
        .document(selectedUserId)
        .setData({
      'userName': selectedUserName,
      'image': selectedUserPhotoUrl,
    });

    return await Firestore.instance
        .collection('users')
        .document(selectedUserId)
        .collection('matchedList')
        .document(currentUserId)
        .setData({
      'userName': currentUserName,
      'image': currentUserPhotoUrl,
    });
  }
}
