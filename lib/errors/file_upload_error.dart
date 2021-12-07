import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileUploadFailedException extends IOException{
  TaskState? state;
  FileUploadFailedException({this.state});

  @override
  String toString() {
    return 'FileUploadFailedException{state: $state}';
  }

}
