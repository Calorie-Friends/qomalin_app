import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/file.dart';
import 'package:qomalin_app/providers/user.dart';

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
  String? _avatarIconUrl;
  final picker = ImagePicker();

  Future _getAvatarIcon() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    setState(() {
      if (pickedFile != null) {
        _avatarIcon = pickedFile;
      } else {
        log('No image selected.');
      }
    });
  }

  @override
  void initState() {
    final fireUser = ref.read(authNotifierProvider).fireAuthUser;
    final isNewAccount = fireUser?.metadata.creationTime == fireUser?.metadata.lastSignInTime;
    if(!isNewAccount) {
      final uid = ref.read(authNotifierProvider).fireAuthUser?.uid;
      ref.read(UserProviders.userRepository()).find(uid!).then((value) {
        _usernameEditingController.text = value.username;
        _descriptionEditingController.text = value.description ?? '';
        setState(() {
          _avatarIconUrl = value.avatarIcon;
        });
      });
    }
    super.initState();
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
              //プロフィール画像
              RawMaterialButton(
                onPressed: _getAvatarIcon,
                child: () {
                  if(_avatarIcon == null && _avatarIconUrl == null) {
                    return const Icon(Icons.person_sharp, size: 150,);
                  }else if(_avatarIcon != null){
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(_avatarIcon!.path)),
                        )
                      ),

                    );
                  }else{
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(_avatarIconUrl!),
                          )
                      ),

                    );
                  }
                }(),
                shape: const CircleBorder(),
              ),
              SizedBox(
                child: Container(
                  height: 50,
                ),
              ),
              //ユーザ名
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
              //自己紹介
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
      //保存ボタン
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () async {
            final fileRepository = ref.read(FileProviders.fileRepositoryProvider());
            final String? avatarIcon;
            if(_avatarIcon != null) {
              avatarIcon = await fileRepository.upload(File(_avatarIcon!.path));
            }else{
              avatarIcon = _avatarIconUrl;
            }
            final userRepository = ref.read(UserProviders.userRepository());
            final uid = ref.read(authNotifierProvider).fireAuthUser?.uid;
            userRepository.save(
                User(
                  id: uid!,
                  username: _usernameEditingController.text,
                  avatarIcon: avatarIcon,
                  description: _descriptionEditingController.text
                )
            ).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('更新に成功しました。'))
              );
            });
          },
          child: const Text("保存"),
        ),
      ],
    );
  }
}