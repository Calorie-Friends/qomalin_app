import 'dart:developer';

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
  //final DocumentReference<User> user;
  final User? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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

  /// 新たに質問オブジェクトを作成するためのFactory
  /// Firestoreには登録されないので別で登録処理を実行すること。
  static Question newQuestion({
      required String title,
      required String text,
      required String userId,
      required double latitude,
      required double longitude,
      required List<String> imageUrls}) {
    final now = DateTime.now();
    return Question(
        id: "",
        title: title,
        text: text,
        address: null,
        location: LocationPoint(latitude: latitude, longitude: longitude),
        user: null,
        userId: userId,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: now);
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode =>
      id.hashCode;
}

class LocationPoint {
  final double latitude;
  final double longitude;
  LocationPoint({required this.latitude, required this.longitude});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationPoint &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}


class QuestionFireDTO {
  final String id;
  final String title;
  final String? text;
  final String? address;
  final LocationPoint location;
  final List<String> imageUrls;
  final String userId;
  final DocumentReference<User> user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const QuestionFireDTO(
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


  static QuestionFireDTO fromEntity(FirebaseFirestore store, Question q) {
    return QuestionFireDTO(
      id: q.id,
      title: q.title,
      text: q.text,
      address: q.address,
      location: q.location,
      user: store.collection("users").withUserConverter().doc(q.userId),
      userId: q.userId,
      createdAt: q.createdAt,
      updatedAt: q.updatedAt,
      imageUrls: q.imageUrls
    );
  }

  Future<Question> toEntity() async {
    return Question(
      id: id,
      title: title,
      text: text,
      address: address,
      location: location,
      user: (await user.get()).data(),
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      imageUrls: imageUrls
    );
  }
  Map<String, dynamic> toMap() {
    final geo = GeoFirePoint(location.latitude, location.longitude);
    return {
      'title': title,
      'text': text,
      'address': address,
      'location': geo.data,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(updatedAt!),
      'userId': userId,
      'user': user,
      'imageUrls': imageUrls
    };
  }

  static QuestionFireDTO fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {
    log("fromDocument:${ds.data()}");
    return fromMap(ds.id, ds.data()!);
  }

  static QuestionFireDTO fromMap(String id, Map<String, dynamic> ds) {
    log("fromMap:$ds");
    final location = ds['location']['geopoint'] as GeoPoint;
    return QuestionFireDTO(
        id: id,
        title: ds['title'],
        text: ds['text'],
        address: ds['address'],
        user: (ds['user'] as DocumentReference).withUserConverter(),
        userId: ds['userId'],
        imageUrls: (ds['imageUrls'] as List<dynamic>?)?.map((el) => el.toString()).toList() ?? [],
        location: LocationPoint(
            latitude: location.latitude, longitude: location.longitude),
        createdAt: ds['createdAt'].toDate(),
        updatedAt: ds['updatedAt'].toDate());
  }
}