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
  final String userId;
  final DocumentReference<User> user;
  final DateTime createdAt;
  final DateTime updatedAt;
  Question({
    required this.id,
    required this.title,
    required this.text,
    required this.address,
    required this.location,
    required this.user,
    required this.userId,
    required this.createdAt,
    required this.updatedAt
  });

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
        userId: ds['user_id'],
        location: LocationPoint(latitude: location.latitude, longitude: location.longitude),
        createdAt: ds['created_at'].toDate(),
        updatedAt: ds['updated_at'].toDate()
    );
  }

  Map<String, dynamic> toMap() {
    final geo = GeoFirePoint(this.location.latitude, this.location.longitude);
    return {
      'title': this.title,
      'text': this.text,
      'address': this.address,
      'location': geo.data,
      'created_at': Timestamp.fromDate(this.createdAt),
      'updated_at': Timestamp.fromDate(this.updatedAt),
      'user_id': this.userId,
      'user': this.user
    };
  }


}

class LocationPoint {
  final double latitude;
  final double longitude;
  LocationPoint({required this.latitude, required this.longitude});


}

void hoge () {
  final geo = Geoflutterfire();
  geo.point(latitude: 134, longitude: 35);

}