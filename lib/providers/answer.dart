import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/repositories/answer_repository.dart';

final _answerRepositoryProvider = Provider<AnswerRepository>((ref) {
  return AnswerRepositoryFirestoreImpl();
});

class AnswerProviders {
  AnswerProviders._();
  static Provider<AnswerRepository> answerRepositoryProvider() {
    return _answerRepositoryProvider;
  }
}

