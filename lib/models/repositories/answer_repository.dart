
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qomalin_app/errors/question_error.dart';
import 'package:qomalin_app/models/entities/answer.dart';

abstract class AnswerRepository{
  Future<Answer> create(Answer answer);
}

class AnswerRepositoryFirestoreImpl extends AnswerRepository{
  @override
  Future<Answer> create(Answer answer) async{
    final questionDoc = await FirebaseFirestore.instance
      .collection('questions')
      .doc(answer.questionId)
      .get();

    if(questionDoc.exists){
      final answerDoc = await FirebaseFirestore.instance
          .collection("questions")
          .doc(answer.questionId)
          .collection('answers')
          .add({'text': answer.text, 'userId': answer.userId, 'createdAt': answer.createdAt, 'updatedAt': answer.updatedAt});

      return Answer(
          id: answerDoc.id,
          text: answer.text,
          questionId: answer.questionId,
          userId: answer.userId,
          user: answer.user,
          createdAt: answer.createdAt,
          updatedAt: answer.updatedAt
      );
    }else{
      throw QuestionNotFoundException();
    }

  }
}