import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/errors/question_error.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/firestore.dart';

abstract class QuestionRepository {
  Future<Question?> create(Question question);
  Future<Question> find(String id);
}

class FirebaseQuestionRepository extends QuestionRepository {
  Reader reader;
  FirebaseQuestionRepository(this.reader);
  @override
  Future<Question?> create(Question question) async {
    final addResult =
        await reader(FirestoreProviders.questionCollectionRefProvider())
            .add(QuestionFireDTO.fromEntity(reader(FirestoreProviders.firestoreProvider()), question));
    final res = await addResult.get();
    return await res.data()?.toEntity();
  }

  @override
  Future<Question> find(String id) async {
    final res = await reader(FirestoreProviders.questionCollectionRefProvider())
          .doc(id)
          .get();
    if(!res.exists) {
      throw QuestionNotFoundException();
    }
    final dto = res.data()!;
    return await dto.toEntity();
  }
}
