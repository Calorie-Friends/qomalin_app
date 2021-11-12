import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/firestore.dart';

abstract class QuestionService {
  Stream<List<Question>> nearQuestions(
      {required double radius,
      required double latitude,
      required double longitude});

  Stream<List<Question>> latestQuestions({int limit = 20});
}

class FirebaseQuestionService extends QuestionService {
  final Reader reader;
  FirebaseQuestionService(this.reader);
  @override
  Stream<List<Question>> nearQuestions(
      {required double radius,
      required double latitude,
      required double longitude}) {
    final collection =
        reader(FirestoreProviders.firestoreProvider()).collection("questions");
    final geo = reader(geoFirestoreProvider);
    return geo
        .collection(collectionRef: collection)
        .within(
            center: GeoFirePoint(latitude, longitude),
            radius: radius,
            field: "location")
        .map((event) => event.map((e) => Question.fromDocument(e)).toList());
  }

  @override
  Stream<List<Question>> latestQuestions({int limit = 20}) {
    return reader(FirestoreProviders.questionCollectionRefProvider())
        .orderBy("created_at", descending: true)
        .limit(limit)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
