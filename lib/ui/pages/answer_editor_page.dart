import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qomalin_app/models/entities/answer.dart';
import 'package:qomalin_app/providers/answer.dart';


class AnswerEditorPage extends ConsumerWidget{
  final String questionId;
  final _textEditingController = TextEditingController();

  AnswerEditorPage({ required this.questionId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回答作成'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            maxLength: 1000,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "回答入力",
              hintText: "必須",
              errorText: null,
            ),
            controller: _textEditingController,
          ),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
            onPressed: () async {
              //TODO: 現在のユーザが未承認だった場合認証画面へ遷移するようにする。
              final uid = FirebaseAuth.instance.currentUser!.uid;
              final text = _textEditingController.text;

              final answer = Answer.newAnswer(text: text, questionId: questionId, userId: uid);
              final answerRepository = ref.read(AnswerProviders.answerRepositoryProvider());
              try{
                await answerRepository.create(answer);
                Navigator.of(context).pop();
              }catch(e){
                const snackBar = SnackBar(content: Text('回答の追加に失敗しました!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text("保存"),
        ),
      ],
    );
  }
}