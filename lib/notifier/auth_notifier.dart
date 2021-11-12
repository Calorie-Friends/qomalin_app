import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/errors/auth_error.dart';
import 'package:qomalin_app/providers/auth.dart';

enum AuthStateType { Authenticated, Unauthorized, Loading }

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
  AuthNotifier(this.reader) : super(AuthState.loading()) {
    reader(firebaseAuthProvider).authStateChanges().listen((event) async {
      if (event == null) {
        this.state = AuthState.unauthorized();
      } else {
        this.state = AuthState.authenticated(event);
      }
    });
  }

  /// Google認証
  Future signInWithGoogle() async {
    try {
      final gUser = await GoogleSignIn(scopes: []).signIn();
      final googleAuth = await gUser?.authentication;
      if (googleAuth == null) {
        throw AuthFailedException();
      }
      final cr = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final uc = await FirebaseAuth.instance.signInWithCredential(cr);
      if (uc.user == null) {
        this.state = AuthState.unauthorized();
      } else {
        this.state = AuthState.authenticated(uc.user!);
      }
    } on FirebaseAuthException {
      this.state = AuthState.unauthorized();
      throw AuthFailedException();
    }
  }
}
