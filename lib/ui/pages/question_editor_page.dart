import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/file.dart';
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

final _images = StateProvider.autoDispose<List<TmpImageFile>>((ref) {
  return [];
});

class QuestionEditorPage extends ConsumerWidget {
  final double? latitude;
  final double? longitude;
  final String? questionId;
  final String? title;
  final String? text;
  final ImagePicker _picker = ImagePicker();


  QuestionEditorPage(
    {Key? key,
      this.latitude,
      this.longitude,
      this.title,
      this.text,
      this.questionId,
    }) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleEditingController = ref.watch(_titleEditingControllerProvider(title));
    final textEditingController = ref.watch(_textEditingControllerProvider(text));
    final titleValidationErrorMsg = ref.watch(_titleValidationMsg);
    final textValidationErrorMsg = ref.watch(_textValidationMsg);
    final imageList = ref.watch(_images);
    final isSending = ref.watch(_isSending);
    final enable = titleValidationErrorMsg == null && textValidationErrorMsg == null && !isSending;

    void pickImage() async {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxHeight: 1280,
        maxWidth: 720
      );
      if(pickedImage != null) {
        final newList = [...imageList, TmpImageFile(imageUrl: null, file: File(pickedImage.path))];
        ref.read(_images.state).state = newList;
      }
    }



    log("images :${imageList.length}");
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
            const SizedBox(height: 16),

            SizedBox(
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length * 2,


                  itemBuilder: (BuildContext context, int index) {
                    if(index % 2 != 0) {
                      return const SizedBox(width: 16);
                    }
                    final file = imageList[index ~/ 2];
                    final ImageProvider provider;
                    if(file.file == null) {
                      provider = NetworkImage(file.imageUrl!);
                    }else{
                      provider = FileImage(file.file!);
                    }
                    return SizedBox(
                      child: Image(
                          image: provider,
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120
                      ),
                    );

                  }
              ),
            ),

          ],
        ),
      ),
      persistentFooterButtons: [
        TextButton.icon(onPressed: pickImage, icon: const Icon(Icons.add_a_photo), label: const Text("写真を追加")),
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
              final imageUrls = await Future.wait(
                imageList.map((e) async {
                  if(e.file == null) {
                    return e.imageUrl!;
                  }else{
                    return await ref.read(FileProviders.fileRepositoryProvider())
                        .upload(e.file!);
                  }
                })
              );

              log("作成準備:title:$title, text:$text, location.latitude:$lat, location.longitude:$lng, imageUrls:$imageUrls");
              final question = Question.newQuestion(
                  title: title,
                  text: text,
                  userId: uid,
                  latitude: lat,
                  longitude: lng,
                  imageUrls: imageUrls);
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
