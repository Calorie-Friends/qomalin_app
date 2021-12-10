import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/user.dart';

class AccountPage extends ConsumerStatefulWidget{
  const AccountPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AccountPageState();
  }
}

class _AccountPageState extends ConsumerState{
  String username = "";
  String? _avatarIconUrl;

  @override
  void initState() {
    final fireUser = ref.read(authNotifierProvider).fireAuthUser;
    final isNewAccount = fireUser?.metadata.creationTime == fireUser?.metadata.lastSignInTime;
    if(!isNewAccount) {
      final uid = ref.read(authNotifierProvider).fireAuthUser?.uid;
      ref.read(UserProviders.userRepository()).find(uid!).then((value) {
        username = value.username;
        setState(() {
          _avatarIconUrl = value.avatarIcon;
        });
      });
    }
    super.initState();
  }

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
                children:[
                  //TODO: firestoreからavatarとusernameを取得してUIに反映する
                  Container(
                    child: () {
                      if(_avatarIconUrl == null) {
                        return const Icon(Icons.person_sharp, size: 60,);
                      }else{
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(_avatarIconUrl!),
                              )
                          ),

                        );
                      }
                    }(),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(username, style: TextStyle(fontSize: 25),),
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
