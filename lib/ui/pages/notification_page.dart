import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/notification.dart' as entity;
import 'package:qomalin_app/providers/notification.dart';
import 'package:qomalin_app/ui/components/circular_avatar.dart';


final _notificationStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.read(NotificationProviders.notificationServiceProvider()).observeAll();
});
class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotifications = ref.watch(_notificationStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("通知"),
      ),
      body: asyncNotifications.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return NotifyCard(notification: data[index]);
            });
        },
        error: (e, st) {
          return Center(
            child: Text("読み込みエラー発生\n$e, $st"),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator()
          );
        }
      )
    );
  }
}


class NotifyCard extends StatelessWidget {
  final entity.Notification notification;
  const NotifyCard({Key? key, required this.notification}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: () {
            switch(notification.type) {
              case entity.NotifyType.answered:
                GoRouter.of(context).push('/questions/${notification.answer?.questionId}/show');
                break;
              case entity.NotifyType.thanked:
                GoRouter.of(context).push('/questions/${notification.thank?.questionId}/show');
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircularAvatarIcon(
                      avatarIconUrl: notification.user?.avatarIcon,
                    ),
                    const SizedBox(width: 8),
                    Text(notification.user?.username ?? '')
                  ],
                ),
                if(notification.type == entity.NotifyType.thanked)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('あなたの回答にお礼が来ました。'),
                      Text('"${notification.thank?.comment ?? ''}"'),
                    ],
                  ),
                if(notification.type == entity.NotifyType.answered)
                  const Text('あなたの質問に回答が来ました。'),
              ],
            ),
          ),
        )
    );
  }
}