
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qomalin_app/converters.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/models/entities/thank.dart';
import 'package:qomalin_app/models/entities/user.dart';

enum NotifyType {
  thanked, answered
}
class Notification {

  final String id;
  final NotifyType type;
  final String recipientId;
  final User? user;
  final String userId;
  final Thank? thank;
  final String? thankId;
  final String? answerId;
  final Answer? answer;
  Notification({
    required this.id,
    required this.type,
    required this.recipientId,
    required this.user,
    required this.userId,
    required this.thank,
    required this.thankId,
    required this.answerId,
    required this.answer,
  });
}

class NotificationFireDTO {
  final String id;
  final NotifyType type;
  final String recipientId;
  final DocumentReference<User?> user;
  final String userId;
  final DocumentReference<ThankFireDTO?>? thank;
  final String? thankId;
  final DocumentReference<AnswerFireDTO?>? answer;
  final String? answerId;

  NotificationFireDTO({
    required this.id,
    required this.type,
    required this.recipientId,
    required this.user,
    required this.userId,
    required this.thank,
    required this.thankId,
    required this.answer,
    required this.answerId
  });

  static NotificationFireDTO fromDocument(DocumentSnapshot<Map<String, dynamic>> ds) {
    final data = ds.data() ?? {};
    return NotificationFireDTO(
        id: ds.id,
        type: ds['type'] == 'answered' ? NotifyType.answered
          : ds['type'] == 'thanked' ? NotifyType.thanked : throw Exception(),
        recipientId: ds['recipientId'],
        user: (ds['user'] as DocumentReference).withUserConverter(),
        userId: ds['userId'],
        thank: (data['thank'] as DocumentReference?)?.withThankConverter(),
        thankId: data['thankId'],
        answer: (data['answer'] as DocumentReference?)?.withAnswerConverter(),
        answerId: data['answerId']
    );
  }

  Future<Notification> toEntity() async {
    final ansSn = await answer?.get();
    final thankSn = await thank?.get();
    return Notification(
      id: id,
      type: type,
      recipientId: recipientId,
      userId: userId,
      user: (await user.get()).data(),
      thank: thankSn?.exists == true ? (await thankSn?.data()?.toEntity()) : null,
      thankId: thankId,
      answer: ansSn?.exists == true ? (await ansSn?.data()?.toEntity()) : null,
      answerId: answerId,
    );
  }

}