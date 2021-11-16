import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  void onQuestionPressed(){
    log('aaa');
  }
  void onUserPressed(){

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: ListView(
      padding: EdgeInsets.all(16),
      children: [QuestionCard(title: 'aaa',text: 'bbb',avataricon: 'ccc',username: 'ddd',onQuestionPressed: onQuestionPressed,onUserPressed: onUserPressed,)],
    ));
  }
}

class QuestionCard extends StatelessWidget {
  @override

  final String title;
  final String text;
  final String? avataricon;
  final String username;
  final VoidCallback onQuestionPressed;
  final VoidCallback onUserPressed;
  QuestionCard({
    Key?key,required this.title,
    required this.text,
    required this.avataricon,
    required this.username,
    required this.onQuestionPressed,
    required this.onUserPressed
  }):super(key:key);

  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: new InkWell(
        onTap: onQuestionPressed,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(text),
              Row(
                children: [
                  new InkWell(
                    onTap: onUserPressed,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avataricon!),

                      radius: 12,
                    ),
                  ),
                  SizedBox(width: 8,),
                  Text(username)
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
