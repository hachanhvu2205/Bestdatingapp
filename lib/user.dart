import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class User {
  String uid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;
  int maxDistance;
  int minAge;
  int maxAge;

  User({
    this.uid,
    this.name,
    this.gender,
    this.interestedIn,
    this.photo,
    this.age,
    this.location,
    this.maxDistance,
    this.minAge,
    this.maxAge,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['userId'] as String,
      name: json['userName'] as String,
      gender: json['userGender'] as String,
      age: json['userAge'] as Timestamp,
      location: json['location'] as GeoPoint,
      interestedIn: json['interestedIn'] as String,
      photo: json['image'] as String,
      maxDistance: json['max_distance'] as int,
      minAge: json['min_age'] as int,
      maxAge: json['max_age'] as int,
    );
  }
}
