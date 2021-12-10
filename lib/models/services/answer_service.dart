import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/errors/question_error.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/providers/firestore.dart';

class AnswerService {
  Stream<List<Answer>> findByQuestion(String questionId) {
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
}