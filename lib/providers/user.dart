import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/repositories/user_repository.dart';

final _userRepositoryProvider = Provider<UserRepository>((ref) => UserRepositoryImpl(ref.read));

class UserProviders {
  static Provider<UserRepository> userRepository() {
    return _userRepositoryProvider;
  }
}
