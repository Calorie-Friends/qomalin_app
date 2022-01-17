import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/errors/question_error.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/providers/firestore.dart';

class AnswerService {
  Stream<List<Answer>> findByQuestion(String questionId) {
    throw UnimplementedError();
  }
  Stream<List<Answer>> findByUser({required String userId}) {
    throw UnimplementedError();
  }
}

class AnswerServiceFirestoreImpl implements AnswerService {
  final Reader reader;
  AnswerServiceFirestoreImpl(this.reader);
  @override
  Stream<List<Answer>> findByQuestion(String questionId) async* {
    final question = await reader(FirestoreProviders.questionCollectionRefProvider())
      .doc(questionId)
      .get();

    if(!question.exists) {
      throw QuestionNotFoundException();
    }

    final answersStream = reader(FirestoreProviders.questionCollectionRefProvider())
      .doc(questionId)
      .collection('answers')
      .withAnswerConverter()
      .orderBy('createdAt')
      .snapshots();

    await for(final answer in answersStream) {
      yield await Future.wait(answer.docs.map((e) async => await e.data().toEntity()).toList());
    }
  }

  @override
  Stream<List<Answer>> findByUser({required String userId}) async*{
    final answersStream = reader(FirestoreProviders.firestoreProvider())
        .collectionGroup('answers')
        .where("userId", isEqualTo: userId)
        .orderBy('createdAt')
        .snapshots();

    await for(final answer in answersStream) {
      final dtoList = answer.docs.map((e) => AnswerFireDTO.fromDocument(e))
        .map((e) => e.toEntity());
      final answers = await Future.wait(dtoList);
      yield answers;
    }
  }
}