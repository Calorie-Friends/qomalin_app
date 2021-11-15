import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String? avatarIcon;

  User({required this.id, required this.username, required this.avatarIcon});

  static User fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {
    return User(id: ds.id, username: ds.get('username'), avatarIcon: ds.get("avatarIcon"));
  }

  Map<String, dynamic> toMap() {
    return {'username': this.username, 'avatarIcon': this.avatarIcon};
  }
}
