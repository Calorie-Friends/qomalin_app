import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String? avatarIcon;

  User({required this.id, required this.username, required this.avatarIcon});

  static User fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {
    final data = ds.data() ?? {};
    return User(
        id: ds.id,
        username: ds.get('username'),
        avatarIcon: data['avatarIcon']
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'avatarIcon': avatarIcon};
  }
}
