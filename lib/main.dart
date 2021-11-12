import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/models/entities/question.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/firestore.dart';
import 'package:qomalin_app/providers/location.dart';
import 'package:qomalin_app/providers/questions.dart';
import 'package:qomalin_app/router.dart';

void main() async {
  await setupWhenBeforeRunApp();
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(router);
    return MaterialApp.router(
      routeInformationParser: r.routeInformationParser,
      routerDelegate: r.routerDelegate,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("致命的なエラー"),
      ),
      body: Center(
        child: Text("致命的なエラーが発生しました"),
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: NearQuestionsExamplePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final uid = ref.read(authNotifierProvider)?.fireAuthUser?.uid;
          final location = await Geolocator.getLastKnownPosition();
          final doc =
              ref.read(FirestoreProviders.userCollectionRefProvider()).doc(uid);
          ref.read(FirestoreProviders.questionCollectionRefProvider()).add(
              Question(
                  id: "",
                  title: "piyo",
                  text: "aaaa",
                  address: null,
                  location: LocationPoint(
                      latitude: location!.latitude,
                      longitude: location.longitude),
                  user: doc,
                  userId: uid,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NearQuestionsExamplePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          print("error?:${snapshot.error}, ${snapshot.stackTrace}");
          return Text("位置情報の取得に失敗しました");
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
                print(snapshot.stackTrace);
                return Text("error:${snapshot.stackTrace}");
              }
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
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

class CurrentLocationExamplePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(locationPositionStreamProvider).when(
        data: (data) {
          print("location:$data");
        },
        error: (e, s, t) {},
        loading: (a) {
          print("location loading");
        });

    ref.watch(locationServiceStatusStreamProvider).when(data: (data) {
      print("data$data");
    }, error: (e, s, t) {
      print("error:$e, $s, $t");
    }, loading: (a) {
      print("loading");
    });
    return Column(
      children: [],
    );
  }
}

Future setupWhenBeforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
