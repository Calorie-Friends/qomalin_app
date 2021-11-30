import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/errors/auth_error.dart';
import 'package:qomalin_app/errors/file_upload_error.dart';
import 'package:qomalin_app/providers/auth.dart';

abstract class FileRepository {
  Future<String> upload(File file);
  Future<List<String>> uploadAll(List<File> files);
}


class FileRepositoryImpl extends FileRepository{
  final Reader reader;
  FileRepositoryImpl(this.reader);
  @override
  Future<String> upload(File file) async {
    final ref = FirebaseStorage.instance.ref();
    final uid = reader(authNotifierProvider).fireAuthUser?.uid;
    if(uid == null) {
      throw UnauthorizedException();
    }
    final task = await ref.child("$uid/${file.path}").putFile(file).whenComplete(() => null);
    if (task.state == TaskState.success) {
      return await task.ref.getDownloadURL();
    }
    throw FileUploadFailedException(state: task.state);
  }

  @override
  Future<List<String>> uploadAll(List<File> files) {
    return Future.wait(files.map((e) => upload(e)));
  }
}