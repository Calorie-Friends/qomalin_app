import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/providers/user.dart';

final _fetchUserFutureProvider =
    FutureProvider.autoDispose.family<User, String>((ref, userId) {
  return ref.read(UserProviders.userRepository()).find(userId);
});

class UserDetailPage extends ConsumerWidget {
  final String userId;

  const UserDetailPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(_fetchUserFutureProvider(userId));
    final body = asyncUser.when(data: (data) {
      //return Text(data.username);
      // Row(
      //   children: [
      //     CircleAvatar(
      //       foregroundImage: data.avatarIcon==null?,
      //       radius: 16,
      //     ),
      //   ],
      // );
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16),
              child: CircleAvatar(
                foregroundImage: data.avatarIcon == null
                    ? const NetworkImage(
                        'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6')
                    : NetworkImage(data.avatarIcon!),
                backgroundImage: const NetworkImage(
                    'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6'),
                radius: 60,
              ),
            ),
            const SizedBox(
              width: 8,
              height: 10,
            ),
            Text(
              data.username,
              style: const TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height:25,
            ),
            Text(
              data.description ?? '',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      );
      //return Image.network(data.avatarIcon ?? '');
    }, error: (e, st) {
      return Text("取得失敗");
    }, loading: () {
      return Text("ローディング");
    });
    return Scaffold(
        appBar: AppBar(
          title: Text("プロフィール"),
        ),
        body: body);
    /*
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage: avatarIcon == null
                  ? const NetworkImage(
                  'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6')
                  : NetworkImage(avatarIcon!),
              backgroundImage: const NetworkImage(
                  'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6'),
              radius: 16,
            ),
            Text(username,
                style: const TextStyle(
                  fontSize: 18,
                )
            ),
            Text(text,
                style: const TextStyle(
                  fontSize: 18,
                )
            )
          ],

        ),

      ),
    );*/
    return Text("userId:${userId}");
  }
}
