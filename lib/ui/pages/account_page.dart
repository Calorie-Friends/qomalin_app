import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("アカウント"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              height: 70,
              child: Row(
                children:const [
                  //TODO: firestoreからavatarとusernameを取得してUIに反映する
                  Icon(Icons.account_circle, size: 80,),
                  SizedBox(
                    width: 30,
                  ),
                  Text("佐藤", style: TextStyle(fontSize: 25),),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              GoRouter.of(context).push("/me/profile/edit");
            },
            child: const Text("プロフィール編集", style: TextStyle(color: Colors.black))
          ),
          TextButton(
            onPressed: (){},
            child: const Text("ログアウト"),
          ),
        ],
      ),
    );
  }
}
