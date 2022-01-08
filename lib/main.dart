import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/firestore.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/router.dart';

void main() async {
  await setupWhenBeforeRunApp();
  runApp(const ProviderScope(child: App()));
}

final _updateDeviceTokenProvider = FutureProvider.autoDispose.family( (ref, String? uid) async {
  if(uid == null) {
    return;
  }
  final String? token;
  if(Platform.isIOS || Platform.isMacOS) {
    token = await FirebaseMessaging.instance.getToken();
  }else{
    token = await FirebaseMessaging.instance.getAPNSToken();
  }

  final privateUserRef = ref.read(FirestoreProviders.firestoreProvider())
    .collection('private_users')
    .doc(uid);
  if(!(await privateUserRef.get()).exists) {
    await privateUserRef.set({});
  }
  await privateUserRef.collection('device_tokens')
    .doc(token)
    .set({});
});

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }

    final r = ref.watch(router);
    ref.watch(_updateDeviceTokenProvider(ref.read(authNotifierProvider).fireAuthUser?.uid))
        .when(data: (d) {

        },
        error: (e,st) {
          log('fcmToken登録失敗 error:$e, stackTrace:$st');
        },
        loading: () {

        });
    return MaterialApp.router(
      routeInformationParser: r.routeInformationParser,
      routerDelegate: r.routerDelegate,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(
            color: Colors.black54
          )
        ),
          tabBarTheme: const TabBarTheme(
              labelColor: Colors.black,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 0xFF, 0xB8, 0x00)))),
        colorScheme: const ColorScheme.light(
          secondary: Color.fromARGB(255, 0xFF, 0xB8, 0x00),
          primary: Color.fromARGB(255, 0xFF, 0xB8, 0x00),

        )),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("致命的なエラー"),
      ),
      body: const Center(
        child: Text("致命的なエラーが発生しました"),
      ),
    );
  }
}


class NearQuestionsExamplePage extends ConsumerWidget {
  const NearQuestionsExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          log("error?:${snapshot.error}, ${snapshot.stackTrace}");
          return const Text("位置情報の取得に失敗しました");
        }

        return StreamBuilder<List<Question>>(
            stream: ref
                .read(QuestionProviders.questionServiceProvider())
                .nearQuestions(
                    radius: 300,
                    latitude: snapshot.data!.latitude,
                    longitude: snapshot.data!.longitude),
            builder: (context, snapshot) {
              final list = snapshot.data;
              if (snapshot.hasError) {
                log(snapshot.stackTrace?.toString() ?? "");
                return Text("error:${snapshot.stackTrace}");
              }
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final geo = ref.read(geoFirestoreProvider);
              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = list?[index];
                  return ListTile(
                    title: Text(item!.title),
                    subtitle: Text(
                        "geohash:${geo.point(latitude: item.location.latitude, longitude: item.location.longitude).hash}"),
                  );
                },
                itemCount: list!.length,
              );
            });
      },
    );
  }
}


Future setupWhenBeforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
