import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: (){
              GoRouter.of(context).push("/me/profile/edit");
            },
            child: const Text("プロフィール編集", style: TextStyle(color: Colors.black))
          ),
        ],
      ),
    );
  }
}
