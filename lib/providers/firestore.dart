import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/converters.dart';

final _firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});


final geoFirestoreProvider = Provider<Geoflutterfire>((ref) {
  return Geoflutterfire();
});



final _userCollectionRefProvider = Provider<CollectionReference<User>>((ref){
  return ref.read(_firestoreProvider).collection('users').withUserConverter();
});

final _questionCollectionRefProvider = Provider<CollectionReference<Question>>((ref) {
  return ref.read(_firestoreProvider).collection('questions').withQuestionConverter();
});



final testsProvider = Provider<CollectionReference<Map<String, dynamic>>>((ref) {
  return ref.read(_firestoreProvider).collection('tests');
});

final testStreamProvider = StreamProvider((ref) {
  return ref.read(testsProvider).snapshots();
});

class FirestoreProviders {
  FirestoreProviders._();

  static Provider<FirebaseFirestore> firestoreProvider() {
    return _firestoreProvider;
  }
  static Provider<CollectionReference<User>> userCollectionRefProvider() {
    return _userCollectionRefProvider;
  }

  static Provider<CollectionReference<Question>> questionCollectionRefProvider() {
    return _questionCollectionRefProvider;
  }
}