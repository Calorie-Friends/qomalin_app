import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/converters.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});


final geoFirestoreProvider = Provider<Geoflutterfire>((ref) {
  return Geoflutterfire();
});



final _userCollectionRefProvider = Provider<CollectionReference<User>>((ref){
  return ref.read(firestoreProvider).collection('users').withUserConverter();
});

final _questionCollectionRefProvider = Provider<CollectionReference<Question>>((ref) {
  return ref.read(firestoreProvider).collection('questions').withQuestionConverter();
});



final testsProvider = Provider<CollectionReference<Map<String, dynamic>>>((ref) {
  return ref.read(firestoreProvider).collection('tests');
});

class FirestoreProviders {
  Provider<CollectionReference<User>> userCollectionRefProvider() {
    return _userCollectionRefProvider;
  }

  Provider<CollectionReference<Question>> questionCollectionRefProvider() {
    return _questionCollectionRefProvider;
  }
}