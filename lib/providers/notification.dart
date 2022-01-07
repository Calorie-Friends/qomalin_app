
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/services/notification_service.dart';

final _notificationServiceProvider = Provider<NotificationService>((ref) => NotificationServiceFirestore(ref.read));

class NotificationProviders {
  NotificationProviders._();
  static Provider<NotificationService> notificationServiceProvider() {
    return _notificationServiceProvider;
  }
}