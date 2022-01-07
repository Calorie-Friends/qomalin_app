import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/errors/auth_error.dart';
import 'package:qomalin_app/models/entities/notification.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/firestore.dart';

class NotificationService {
  Stream<List<Notification>> observeAll() {
    throw UnimplementedError();
  }
}

class NotificationServiceFirestore implements NotificationService {
  final Reader reader;
  NotificationServiceFirestore(this.reader);
  @override
  Stream<List<Notification>> observeAll() async* {
    final uid = reader(authNotifierProvider).fireAuthUser?.uid;
    if (uid == null) {
      throw UnauthorizedException();
    }
    final notifications = reader(FirestoreProviders.firestoreProvider())
      .collection('users')
      .doc(uid)
      .collection('notifications')
      .orderBy('createdAt', descending: true)
      .snapshots();
    await for(var list in notifications) {
      final notificationDTOs = list.docs.where((element) => element.exists)
          .map((e) => NotificationFireDTO.fromDocument(e))
          .map((e) => e.toEntity());
      yield await Future.wait(notificationDTOs);
    }
  }

}