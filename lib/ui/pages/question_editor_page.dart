import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/questions.dart';

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

class TmpImageFile {
  final String? imageUrl;
  final File? file;
  TmpImageFile({
    required this.imageUrl,
    required this.file
  });
}

final _titleEditingControllerProvider = Provider
    .autoDispose
    .family<TextEditingController, String?>((ref, initial) {
        return TextEditingController.fromValue(
            TextEditingValue(text: initial ?? '')
        );
    });
final _textEditingControllerProvider = Provider
    .autoDispose
    .family<TextEditingController, String?>((ref, initial) {
        return TextEditingController.fromValue(
            TextEditingValue(text: initial ?? '')
        );
    });

final _isSending = StateProvider.autoDispose((ref) => false);

final _images = StateProvider.autoDispose.family<List<TmpImageFile>, List<TmpImageFile>?>((ref, tmpFiles) {
  if(tmpFiles == null) {
    return [];
  }
  return tmpFiles;
});

class QuestionEditorPage extends ConsumerWidget {
  final double? latitude;
  final double? longitude;
  final String? questionId;
  final String? title;
  final String? text;


  const QuestionEditorPage(
    {Key? key,
      this.latitude,
      this.longitude,
      this.title,
      this.text,
      this.questionId
    }) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleEditingController = ref.watch(_titleEditingControllerProvider(title));
    final textEditingController = ref.watch(_textEditingControllerProvider(text));
    final titleValidationErrorMsg = ref.watch(_titleValidationMsg);
    final textValidationErrorMsg = ref.watch(_textValidationMsg);
    final isSending = ref.watch(_isSending);
    final enable = titleValidationErrorMsg == null && textValidationErrorMsg == null && !isSending;
    return Scaffold(
      appBar: AppBar(
        title: const Text('こまりん作成'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //タイトル
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "タイトル入力",
                hintText: "必須",
                errorText: titleValidationErrorMsg,
                enabled: !isSending,
              ),
              onChanged: (text) {
                ref.read(_titleStateProvider.state).state = text;
              },
              controller: titleEditingController,
            ),
            const SizedBox(height: 16),
            //本文
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "本文入力",
                hintText: "必須",
                errorText: textValidationErrorMsg,
                enabled: !isSending,
              ),
              controller: textEditingController,
              onChanged: (text) {
                ref.read(_textStateProvider.state).state = text;
              },
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
            ref.read(_isSending.state).state = true;
            final uid = FirebaseAuth.instance.currentUser!.uid;
            final title = titleEditingController.text;
            final text = textEditingController.text;
            final double lat;
            final double lng;

            try {
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
              await ref
                  .read(QuestionProviders.questionRepositoryProvider())
                  .create(question);
              Navigator.of(context).pop();
            } catch(e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("エラーが発生したため作成に失敗しました。")
              ));
            } finally {
              ref.read(_isSending.state).state = false;
            }
          } : null,
          child: const Text("保存"),
        ),
      ],
    );
  }
}
