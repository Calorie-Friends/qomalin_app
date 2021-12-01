import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';

class QuestionEditorPage extends ConsumerStatefulWidget {
  final double? latitude;
  final double? longitude;
  const QuestionEditorPage({this.latitude, this.longitude ,Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  ConsumerState<ConsumerStatefulWidget> createState() => QuestionEditorState(latitude: latitude, longitude: longitude);
}

class QuestionEditorState extends ConsumerState {
  final _titleEditingController = TextEditingController();
  final _textEditingController = TextEditingController();
  final double? latitude;
  final double? longitude;


  QuestionEditorState(
    {Key? key,
      this.latitude,
      this.longitude
    });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('こまりん作成'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //タイトル
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "タイトル入力",
                  hintText: "必須",
                  errorText: null,
                ),
                controller: _titleEditingController,
              ),
            ),
            //本文
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "本文入力",
                  hintText: "必須",
                ),
                controller: _textEditingController,
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () async {
            //TODO: 現在のユーザが未認証状態だった場合認証画面へ遷移するようにする。
            final uid = FirebaseAuth.instance.currentUser!.uid;
            final title = _titleEditingController.text;
            final text = _textEditingController.text;
            final double lat;
            final double lng;

            if(latitude == null || longitude == null){
              final location = await Geolocator.getCurrentPosition();
              lat = location.latitude;
              lng = location.longitude;
            }else{
              lat = latitude!;
              lng = longitude!;
            }
            log("作成準備:title:$title, text:$text, location.latitude:$lat, location.longitude:$lng");
            final question = Question.newQuestion(
                title: title,
                text: text,
                userId: uid,
                latitude: lat,
                longitude: lng,
                imageUrls: []);
            //TODO: 作成状態を画面に表示する
            //FIXME: 例外処理をすること
            await ref
                .read(QuestionProviders.questionRepositoryProvider())
                .create(question);
            Navigator.of(context).pop();
          },
          child: const Text("保存"),
        ),
      ],
    );
  }
}
