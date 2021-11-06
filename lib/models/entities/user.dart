
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;

  User({
    required this.id,
    required this.username
  });

  static User fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {

    return User(
      id: ds.id,
      username: ds.get('username')
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'username': this.username
    };
  }




}

