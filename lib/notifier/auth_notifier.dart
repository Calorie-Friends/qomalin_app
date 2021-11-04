
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/auth.dart';

enum AuthStateType {
  Authenticated, Unauthorized, Loading
}
class AuthState {
  final AuthStateType type;
  final User? fireAuthUser;

  AuthState({required this.type, required this.fireAuthUser});
  factory AuthState.loading() {
    return AuthState(type: AuthStateType.Loading, fireAuthUser: null);
  }
  factory AuthState.authenticated(User user) {
    return AuthState(type: AuthStateType.Authenticated, fireAuthUser: user);
  }

  factory AuthState.unauthorized() {
    return AuthState(type: AuthStateType.Unauthorized, fireAuthUser: null);
  }
}


class AuthNotifier extends StateNotifier {
  final Reader reader;
  AuthNotifier(this.reader) : super(AuthState.loading())  {
    reader(firebaseAuthProvider).authStateChanges().listen((event) async {
      if(event == null) {
        this.state = AuthState.unauthorized();
      }else{
        this.state = AuthState.authenticated(event);
      }
    });
  }
}