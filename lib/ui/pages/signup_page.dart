import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/auth.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignupState();
  }
}

class _SignupState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBar(title: const Text("認証")),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(Buttons.Google, onPressed: () {
                  authNotifier.signInWithGoogle().then((value) {
                    GoRouter.of(context).push('/');
                  }).onError((e, st) {
                    print("error e:$e, st:$st");
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("認証に失敗しました")));
                  });
                })
              ],
            ),
          ),
        ));
  }
}
