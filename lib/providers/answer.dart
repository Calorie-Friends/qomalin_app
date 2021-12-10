import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/repositories/answer_repository.dart';
import 'package:qomalin_app/models/services/answer_service.dart';

final _answerRepositoryProvider = Provider<AnswerRepository>((ref) {
  return AnswerRepositoryFirestoreImpl(ref.read);
});

final _answerServiceProvider = Provider<AnswerService>((ref) {
  return AnswerServiceFirestoreImpl(ref.read);
});

class AnswerProviders {
  AnswerProviders._();
  static Provider<AnswerRepository> answerRepositoryProvider() {
    return _answerRepositoryProvider;
  }

  static Provider<AnswerService> answerServiceProvider() {
    return _answerServiceProvider;
  }
}

