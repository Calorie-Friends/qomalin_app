import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qomalin_app/ui/components/question_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void onQuestionPressed() {
    log('aaa');
  }

  void onUserPressed() {}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('ホーム'),
              bottom: const TabBar(tabs: <Widget>[
                Tab(text: '近く'),
                Tab(text: '最近'),
              ]),
            ),
            body: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    QuestionCard(
                      title: '自販機が使えないです。',
                      text: '自販機が使えないので助けてください！',
                      avatarIcon:
                          'https://avatars.githubusercontent.com/u/65577595?v=4',
                      username: 'tak2355',
                      onQuestionPressed: onQuestionPressed,
                      onUserPressed: onUserPressed,
                    )
                  ],
                ),
                const Center(
                  child: Text('最近'),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                GoRouter.of(context).push("/questions/edit");
              },
            )
        )
    );
  }
}


