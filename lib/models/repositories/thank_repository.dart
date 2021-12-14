
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/errors/answer_error.dart';
import 'package:qomalin_app/errors/question_error.dart';
import 'package:qomalin_app/errors/thank_error.dart';
import 'package:qomalin_app/models/entities/thank.dart';
import 'package:qomalin_app/providers/firestore.dart';

class ThankRepository {
  Future<Thank> create(Thank thank) {
    throw UnimplementedError();
  }
}

class ThankRepositoryFirestoreImpl implements ThankRepository {
  final Reader reader;
  ThankRepositoryFirestoreImpl(this.reader);
  @override
  Future<Thank> create(Thank thank) async {
    final question = await reader(FirestoreProviders.questionCollectionRefProvider())
        .doc(thank.questionId).get();
    if(!question.exists) {
      throw QuestionNotFoundException();
    }
    final answer = await question.reference.collection("answers").withAnswerConverter()
        .doc(thank.answerId).get();
    if(!answer.exists) {
      throw AnswerNotFoundException();
    }
    final addResult = await answer.reference.collection("thanks").withThankConverter()
      .add(ThankFireDTO.fromEntity(reader, thank));
    final dto = await addResult.get();
    if(!dto.exists) {
      throw AnswerCreateFailedException();
    }
    return await dto.data()!.toEntity();
  }

}