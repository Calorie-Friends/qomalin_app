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
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final r = ref.watch(router);
    return MaterialApp.router(
      routeInformationParser: r.routeInformationParser,
      routerDelegate: r.routerDelegate,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black54,
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(
            color: Colors.black54
          )
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.black,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Color.fromARGB(255, 0xFF, 0xB8, 0x00))
          )
        ),
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
      body: const NearQuestionsExamplePage(),
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
                  imageUrls: const [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
          print("error?:${snapshot.error}, ${snapshot.stackTrace}");
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
                print(snapshot.stackTrace);
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

class CurrentLocationExamplePage extends ConsumerWidget {
  const CurrentLocationExamplePage({Key? key}) : super(key: key);

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
      children: const [],
    );
  }
}

Future setupWhenBeforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
