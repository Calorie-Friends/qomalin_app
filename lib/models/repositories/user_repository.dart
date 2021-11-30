import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/errors/user_error.dart';
import 'package:qomalin_app/models/entities/user.dart';
import 'package:qomalin_app/providers/firestore.dart';

abstract class UserRepository{
  Future<User> save(User user);
  Future<User?> findByUserName(String username);
  Future<User> find(String id);
}

class UserRepositoryImpl extends UserRepository{
  Reader reader;
  UserRepositoryImpl(this.reader);
  @override
  Future<User> save(User user) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<User?> findByUserName(String username) async{
    final getResult =
      await reader(FirestoreProviders.firestoreProvider())
        .collection('usernames').doc(username).get();
    final userId = getResult.get("userId");
    return find(userId);
  }

  @override
  Future<User> find(String id) async{
    final getResult =
      await reader(FirestoreProviders.userCollectionRefProvider())
        .doc(id).get();
    final user =  getResult.data();
    if(user == null){
      throw UserNotFoundException();
    }
    return user;
  }
}