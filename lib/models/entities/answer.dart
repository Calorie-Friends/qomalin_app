import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Answer {
  final String id;
  final String text;
  final String questionId;
  final String userId;
  final DocumentReference<User> user;
  final DateTime createdAt;
  final DateTime updatedAt;
  Answer({
    required this.id,
    required this.text,
    required this.questionId,
    required this.userId,
    required this.user,
    required this.createdAt,
    required this.updatedAt
  });


}
