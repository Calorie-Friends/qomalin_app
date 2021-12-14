import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qomalin_app/ui/pages/latest_question_page.dart';
import 'package:qomalin_app/ui/pages/near_question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                LatestQuestionPage(),
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


