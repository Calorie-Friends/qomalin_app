import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/repositories/file_repository.dart';

final _fileRepositoryProvider = Provider<FileRepository>((ref) => FileRepositoryImpl(ref.read));

class FileProviders {
  FileProviders._();
  static Provider<FileRepository> fileRepositoryProvider() {
    return _fileRepositoryProvider;
  }
}
