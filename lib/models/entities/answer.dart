import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/models/entities/user.dart';

class Answer {
  final String id;
  final String text;
  final String questionId;
  final String userId;
  final User user;
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

class AnswerFireDTO {
  final String id;
  final String text;
  final String questionId;
  final String userId;
  final DocumentReference<User> user;
  final DateTime createdAt;
  final DateTime updatedAt;
  AnswerFireDTO(
      {required this.id,
      required this.text,
      required this.questionId,
      required this.userId,
      required this.user,
      required this.createdAt,
      required this.updatedAt});

  static AnswerFireDTO fromMap(String id, Map<String, dynamic> data){
    return AnswerFireDTO(
        id: id,
        text: data['text'],
        questionId: data['questionId'],
        userId: data['userId'],
        user: data['user'],
        createdAt: data['createdAt'].toDate(),
        updatedAt: data['updatedAt'].toDate()
    );
  }

  static AnswerFireDTO fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    return fromMap(document.id, document.data()!);
  }

  static AnswerFireDTO fromEntity(FirebaseFirestore firestore, Answer answer) {
    return AnswerFireDTO(
        id: answer.id,
        text: answer.text,
        questionId: answer.questionId,
        userId: answer.userId,
        user: firestore.collection("users").withUserConverter().doc(answer.userId),
        createdAt: answer.createdAt,
        updatedAt: answer.updatedAt
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'questionId': questionId,
      'userId': userId,
      'user': user,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt)
    };
  }

  Future<Answer> toEntity() async {
    return Answer(
        id: id,
        text: text,
        questionId:
        questionId,
        userId: userId,
        user: (await user.get()).data()!,
        createdAt:
        createdAt,
        updatedAt: updatedAt
    );
  }


}


