import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  void onQuestionPressed(){
    log('aaa');
  }
  void onUserPressed(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
        padding: const EdgeInsets.all(16),
        children: [QuestionCard(title: '自販機が使えないです。',text: '自販機が使えないので助けてください！',avatarIcon: 'https://avatars.githubusercontent.com/u/65577595?v=4',username: 'tak2355',onQuestionPressed: onQuestionPressed,onUserPressed: onUserPressed,)],
      ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            GoRouter.of(context).push( "/questions/edit");
          },
        )
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String title;
  final String text;
  final String? avatarIcon;
  final String username;
  final VoidCallback onQuestionPressed;
  final VoidCallback onUserPressed;
  const QuestionCard({
    Key?key,required this.title,
    required this.text,
    required this.avatarIcon,
    required this.username,
    required this.onQuestionPressed,
    required this.onUserPressed
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: InkWell(
        onTap: onQuestionPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8,),
              Text(text,maxLines: 2,),
              const SizedBox(height: 8,),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onUserPressed,
                    child: CircleAvatar(
                      foregroundImage: avatarIcon == null ? const NetworkImage('https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6') : NetworkImage(avatarIcon!),
                      backgroundImage: const NetworkImage('https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1703/tuktukdesign170300061/73583439-%E7%94%B7%E3%83%A6%E3%83%BC%E3%82%B6%E3%83%BC-%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3-%E3%83%97%E3%83%AD%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB-%E3%82%A2%E3%83%90%E3%82%BF%E3%83%BC-%E3%82%B0%E3%83%AA%E3%83%95-%E3%83%99%E3%82%AF%E3%83%88%E3%83%AB-%E3%82%A4%E3%83%A9%E3%82%B9%E3%83%88.jpg?ver=6'),
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Text(username,
                    style: const TextStyle(
                      fontSize: 18,)
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
