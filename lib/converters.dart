import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/models/entities/question.dart';

import 'models/entities/user.dart';

extension DocumentReferenceT<T> on DocumentReference {
  DocumentReference<User> withUserConverter() {
    return withConverter(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> ds, _) {
      return User.fromDocument(ds);
    }, toFirestore: (User user, _) {
      return user.toMap();
    });
  }

  DocumentReference<AnswerFireDTO> withAnswerConverter() {
    return withConverter(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> ds, _) {
          return AnswerFireDTO.fromDocument(ds);
        }, toFirestore: (AnswerFireDTO answer, _) {
      return answer.toMap();
    });
  }
}

extension CollectionReferenceT<T> on CollectionReference {
  CollectionReference<User> withUserConverter() {
    return withConverter(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> ds, _) {
      return User.fromDocument(ds);
    }, toFirestore: (User user, _) {
      return user.toMap();
    });
  }

  CollectionReference<QuestionFireDTO> withQuestionConverter() {
    return withConverter(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> ds, _) {
      return QuestionFireDTO.fromDocument(ds);
    }, toFirestore: (QuestionFireDTO question, _) {
      return question.toMap();
    });
  }

  CollectionReference<AnswerFireDTO> withAnswerConverter() {
    return withConverter(
        fromFirestore: (DocumentSnapshot<Map<String, dynamic>> ds, _) {
          return AnswerFireDTO.fromDocument(ds);
        }, toFirestore: (AnswerFireDTO answer, _) {
      return answer.toMap();
    });
  }
}
