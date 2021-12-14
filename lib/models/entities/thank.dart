
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/providers/firestore.dart';

class Thank {
  final String id;
  final String? comment;
  final String userId;
  final User? user;
  final String answerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Thank({
    required this.id,
    required this.comment,
    required this.userId,
    required this.user,
    required this.answerId,
    required this.createdAt,
    required this.updatedAt
  });

  static Thank newThank({required String userId, required String answerId, required String? comment}) {
    return Thank(
        id: "",
        comment: comment,
        userId: userId,
        user: null,
        answerId: answerId,
        createdAt: null,
        updatedAt: null
    );
  }
}

class ThankFireDTO {
  final String id;
  final String? comment;
  final String userId;
  final DocumentReference<User> userRef;
  final String answerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ThankFireDTO({
    required this.id,
    required this.comment,
    required this.userId,
    required this.userRef,
    required this.answerId,
    required this.createdAt,
    required this.updatedAt
  });

  static ThankFireDTO fromEntity(Reader reader, Thank thank) {
    final userCollectionRef = reader(FirestoreProviders.userCollectionRefProvider());
    return ThankFireDTO(
        id: thank.id,
        comment: thank.comment,
        userId: thank.userId,
        userRef: userCollectionRef.doc(thank.userId),
        answerId: thank.answerId,
        createdAt: thank.createdAt,
        updatedAt: thank.updatedAt
    );
  }

  static ThankFireDTO fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {
    final data = ds.data() ?? {};
    return ThankFireDTO(
        id: ds.id,
        comment: data['comment'],
        userId: data['userId'],
        userRef: (data['user'] as DocumentReference).withUserConverter(),
        answerId: data['answerId'],
        createdAt: data['createdAt'].toDate(),
        updatedAt: data['updatedAt'].toDate()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'userId': userId,
      'user': userRef,
      'answerId': answerId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp()
    };
  }

  Future<Thank> toEntity() async{
    final user = await userRef.get();
    return Thank(
        id: id,
        comment: comment,
        userId: userId, user: user.data(),
        answerId: answerId,
        createdAt: createdAt,
        updatedAt: updatedAt
    );
  }
}

