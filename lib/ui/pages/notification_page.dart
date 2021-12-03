import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //TODO: 以下はテスト用のボタンなので後で削除する
        child: TextButton(onPressed: (){
          GoRouter.of(context).push("/questions/hoge/answers/create");
        }, child: const Text("test")),
      ),
    );
  }
}
