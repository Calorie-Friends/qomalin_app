import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditorPage extends ConsumerStatefulWidget{
  const ProfileEditorPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return ProfileEditorState();
  }

}

class ProfileEditorState extends ConsumerState{
  final _usernameEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  XFile? _avatarIcon;
  final picker = ImagePicker();

  Future _getAvatarIcon() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _avatarIcon = pickedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              InkWell(
                onTap: _getAvatarIcon,
                child: () {
                  if(_avatarIcon == null) {
                    return Icon(Icons.person_sharp, size: 100,);
                  }else{
                    return Image.file(File(_avatarIcon!.path), width: 100, height:100, fit: BoxFit.cover,);
                  }
                }(),
              ),
              SizedBox(
                child: Container(
                  height: 50,
                ),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 1,
                maxLength: 20,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "ユーザー名",
                  errorText: null,
                ),
                controller: _usernameEditingController,
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "自己紹介",
                  errorText: null,
                ),
                controller: _descriptionEditingController,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text("保存"),
        ),
      ],
    );
  }
}