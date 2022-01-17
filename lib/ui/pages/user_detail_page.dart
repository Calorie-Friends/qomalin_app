import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/providers/user.dart';
import 'package:qomalin_app/ui/components/user_answers_list.dart';
import 'package:qomalin_app/ui/components/user_questions_list.dart';

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

    if (asyncUser is AsyncLoading) {
      return Scaffold(
          appBar: AppBar(title: const Text("プロフィール")),
          body: Center(
            child: CircularProgressIndicator(),
          ));
    }
    if (asyncUser is AsyncError) {
      return Scaffold(
          appBar: AppBar(title: const Text("プロフィール")),
          body: Center(
            child: Text("error"),
          ));
    }
    final user = asyncUser.value!;

    final header = Column(
      children: [
        const SizedBox(
          height: 120,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          child: CircleAvatar(
            foregroundImage: user.avatarIcon == null
                ? const NetworkImage(
                    'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6')
                : NetworkImage(user.avatarIcon!),
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
          user.username,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          user.description ?? '',
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
    final headerView = SizedBox(
      child: header,
    );

    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxesScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 350,
                  flexibleSpace: FlexibleSpaceBar(
                    background: headerView,
                  ),
                  bottom: const TabBar(
                    tabs: [
                      Tab(
                        text: "質問",
                      ),
                      Tab(text: "回答")
                    ],
                  ),
                ),
                SliverList(delegate: SliverChildListDelegate([])),
              ];
            },
            body: TabBarView(
              children: [
                UserQuestionList(userId),
                UserAnswersList(userId)
              ],
            ),
          )),
    );
  }
}
