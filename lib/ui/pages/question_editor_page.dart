import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionEditorPage extends ConsumerStatefulWidget{

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return QuestionEditorState();
  }
}

class QuestionEditorState extends ConsumerState{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('こまりん作成'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //タイトル
            Container(
              margin: EdgeInsets.all(16),
              child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "タイトル入力",
                  hintText: "必須",
                ),
              ),
            ),
            //本文
            Container(
              margin: EdgeInsets.all(16),
              child: const TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "本文入力",
                  hintText: "必須",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}