import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/errors/auth_error.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/user.dart';


final _userFutureProvider = FutureProvider.autoDispose((ref) async {

  final uid = ref.read(authNotifierProvider).fireAuthUser?.uid;
  if(uid == null) {
    throw UnauthorizedException();
  }
  return await ref.read(UserProviders.userRepository())
      .find(uid);
});

class AccountPage extends ConsumerWidget{
  const AccountPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, ref) {
    final body = ref.watch(_userFutureProvider).map(
      data: (data) {
        return Column(
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                height: 70,
                child: Row(
                  children:[
                    Container(
                      child: () {
                        if(data.value.avatarIcon == null) {
                          return const Icon(Icons.person_sharp, size: 60,);
                        }else{
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(data.value.avatarIcon!),
                                )
                            ),

                          );
                        }
                      }(),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(data.value.username, style: const TextStyle(fontSize: 25),),
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
              onPressed: (){
                //TODO: ログアウトを実装する
              },
              child: const Text("ログアウト"),
            ),
          ],
        );
      },
      error: (err) {
        return const Text("取得に失敗しました。");
      },
      loading: (e) {
         return const Center(
           child: CircularProgressIndicator(),
         );
      }
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("アカウント"),
      ),
      body: body
    );
  }
}
