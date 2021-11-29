import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/ui/components/question_card_list.dart';
import 'package:qomalin_app/ui/pages/near_question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onQuestionPressed(Question question) {
    log('questionが押されました。');
  }

  void onUserPressed(User user) {
    log('userが押されました。');
  }

  List <Question> questions = [
    Question(id: 'iefagwea456',
        title: 'トイレを探しています',
        text: 'トイレを探しています',
        address: '日本　大阪',
        location: LocationPoint(latitude: 0.00,longitude: 0.00),
        user: User(id: 'aeag',username: 'agrgega',avatarIcon: ''),
        userId: 'aifejfeagj;agja;',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrls: const ['adfiejfiow']
    )
  ];

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
                const NearQuestionPage(),
                QuestionCardList(onQuestionSelectedListener: onQuestionPressed, onQuestionUserPressedListener: onUserPressed, questions: questions)
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


