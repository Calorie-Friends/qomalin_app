import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/services/question_service.dart';

final _questionServiceProvider =
    Provider((ref) => FirebaseQuestionService(ref.read));

class QuestionProviders {
  QuestionProviders._();

  static Provider<QuestionService> questionServiceProvider() {
    return _questionServiceProvider;
  }
}
