import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/repositories/question_repository.dart';
import 'package:qomalin_app/models/services/question_service.dart';

final _questionServiceProvider =
    Provider((ref) => FirebaseQuestionService(ref.read));

final _questionRepositoryProvider =
    Provider((ref) => FirebaseQuestionRepository(ref.read));

class QuestionProviders {
  QuestionProviders._();

  static Provider<QuestionService> questionServiceProvider() {
    return _questionServiceProvider;
  }

  static Provider<QuestionRepository> questionRepositoryProvider() {
    return _questionRepositoryProvider;
  }
}
