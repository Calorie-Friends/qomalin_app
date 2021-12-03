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


final _titleStateProvider = StateProvider.autoDispose<String>((ref) => '');

final _titleValidationMsg = StateProvider.autoDispose<String?>((ref) {
  final text = ref.watch(_titleStateProvider);
  if(text.isEmpty || text.length < 2) {
    return '2文字以上入力する必要があります。';
  }
  if(text.length > 20) {
    return '20文字より多く入力できません。';
  }
  return null;
});

final _textStateProvider = StateProvider.autoDispose<String>((ref) => '');

final _textValidationMsg = StateProvider.autoDispose<String?>((ref) {
  final text = ref.watch(_textStateProvider);

  if(text.length > 1000) {
    return '1000文字より多く入力できません。';
  }
  return null;
});

class QuestionEditorState extends ConsumerState {
  final _titleEditingController = TextEditingController();
  final _textEditingController = TextEditingController();
  final double? latitude;
  final double? longitude;


  QuestionEditorState(
    {Key? key,
      this.latitude,
      this.longitude,
    });


  @override
  Widget build(BuildContext context) {

    final titleValidationErrorMsg = ref.watch(_titleValidationMsg);
    final textValidationErrorMsg = ref.watch(_textValidationMsg);
    final enable = titleValidationErrorMsg == null || textValidationErrorMsg == null;
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "タイトル入力",
                  hintText: "必須",
                  errorText: titleValidationErrorMsg,
                ),
                onChanged: (text) {
                  ref.read(_titleStateProvider.state).state = text;
                },
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "本文入力",
                  hintText: "必須",
                  errorText: textValidationErrorMsg
                ),
                controller: _textEditingController,
                onChanged: (text) {
                  ref.read(_textStateProvider.state).state = text;
                },
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: enable ? () async {
            if(!enable) {
              return;
            }
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
          } : null,
          child: const Text("保存"),
        ),
      ],
    );
  }
}
