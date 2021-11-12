import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/firestore.dart';

abstract class QuestionRepository {
  Future<Question?> create(Question question);
}

class FirebaseQuestionRepository extends QuestionRepository {
  Reader reader;
  FirebaseQuestionRepository(this.reader);
  @override
  Future<Question?> create(Question question) async {
    final addResult =
        await reader(FirestoreProviders.questionCollectionRefProvider())
            .add(question);
    final res = await addResult.get();
    return res.data();
  }
}
