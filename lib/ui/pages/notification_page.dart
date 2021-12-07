import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qomalin_app/ui/components/answer_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

        children: [
          AnswerCard(text: 'cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc', avatarIcon: null, username: 'dddddddddddddddddd', onAnswerPressed: (){}, onUserPressed: (){},favorite: 8,onFavoritePressed: (){},)
        ],
      )
    );
  }
}
