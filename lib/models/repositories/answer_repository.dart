
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/errors/question_error.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/providers/firestore.dart';

abstract class AnswerRepository{
  Future<Answer> create(Answer answer);
}

class AnswerRepositoryFirestoreImpl extends AnswerRepository{
  final Reader reader;
  AnswerRepositoryFirestoreImpl(this.reader);
  @override
  Future<Answer> create(Answer answer) async{
    final questionDoc = await reader(FirestoreProviders.firestoreProvider())
      .collection('questions')
      .doc(answer.questionId)
      .get();

    if(questionDoc.exists){
      final answerDTO = AnswerFireDTO.fromEntity(FirebaseFirestore.instance, answer);
      final answerDoc = await reader(FirestoreProviders.firestoreProvider())
          .collection("questions")
          .doc(answer.questionId)
          .collection('answers')
          .withAnswerConverter()
          .add(answerDTO);

      return Answer(
          id: answerDoc.id,
          text: answer.text,
          questionId: answer.questionId,
          userId: answer.userId,
          user: answer.user,
          createdAt: answer.createdAt,
          updatedAt: answer.updatedAt,
          thankIds: answer.thankIds,
      );
    }

    throw QuestionNotFoundException();
  }
}