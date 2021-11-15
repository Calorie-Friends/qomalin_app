import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/converters.dart';

@immutable
class Question {
  final String id;
  final String title;
  final String? text;
  final String? address;
  final LocationPoint location;
  final List<String> imageUrls;
  final String userId;
  final DocumentReference<User> user;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Question(
      {required this.id,
      required this.title,
      required this.text,
      required this.address,
      required this.location,
      required this.user,
      required this.userId,
      required this.createdAt,
      required this.updatedAt,
      required this.imageUrls});

  static Question fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {
    print("fromDocument:${ds.data()}");
    return fromMap(ds.id, ds.data()!);
  }

  static Question fromMap(String id, Map<String, dynamic> ds) {
    print("fromMap:$ds");
    final location = ds['location']['geopoint'] as GeoPoint;
    return Question(
        id: id,
        title: ds['title'],
        text: ds['text'],
        address: ds['address'],
        user: (ds['user'] as DocumentReference).withUserConverter(),
        userId: ds['userId'],
        imageUrls: ds['imageUrls'] ?? [],
        location: LocationPoint(
            latitude: location.latitude, longitude: location.longitude),
        createdAt: ds['createdAt'].toDate(),
        updatedAt: ds['updatedAt'].toDate());
  }

  /// 新たに質問オブジェクトを作成するためのFactory
  /// Firestoreには登録されないので別で登録処理を実行すること。
  static Question newQuestion(
    FirebaseFirestore store, {
    required String title,
    required String text,
    required String userId,
    required double latitude,
    required double longitude,
    required List<String> imageUrls
  }) {
    final userRef = store.collection("users").doc(userId).withUserConverter();
    final now = DateTime.now();
    return Question(
        id: "",
        title: title,
        text: text,
        address: null,
        location: LocationPoint(latitude: latitude, longitude: longitude),
        user: userRef,
        userId: userId,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: now);
  }

  Map<String, dynamic> toMap() {
    final geo = GeoFirePoint(location.latitude, location.longitude);
    return {
      'title': title,
      'text': text,
      'address': address,
      'location': geo.data,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'userId': userId,
      'user': user
    };
  }
}

class LocationPoint {
  final double latitude;
  final double longitude;
  LocationPoint({required this.latitude, required this.longitude});
}

void hoge() {
  final geo = Geoflutterfire();
  geo.point(latitude: 134, longitude: 35);
}
