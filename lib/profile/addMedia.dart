import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  File _image;
  final picker = ImagePicker();

  getImage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
    uploadPic();
  }

  Future uploadPic() async {
    String fileName = 'images/${DateTime.now()}.png';
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Media'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text('Create New'),
                Text('Select a content type'),
              ],
            ),
            SizedBox(
              height: 100,
            ),
            gallery(context),
            SizedBox(
              height: 50,
            ),
            camera(context),
          ],
        ),
      ),
    );
  }

  Center camera(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16)),
            height: 100,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                    child: Text(
                      'Capture from',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                    child: Text(
                      'Camera',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 5,
            bottom: 20,
            child: Image.asset(
              'assets/icon-2.png',
              width: 50,
              height: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget gallery(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          getImage(ImageSource.gallery);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16)),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
                      child: Text(
                        'Upload from',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 5, 0, 0),
                      child: Text(
                        'Gallery',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 5,
              bottom: 20,
              child: Image.asset(
                'assets/icon-1.png',
                width: 50,
                height: 50,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
