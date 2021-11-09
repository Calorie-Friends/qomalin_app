import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qomalin_app/providers/auth.dart';
import 'package:qomalin_app/providers/firestore.dart';
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
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
    );
  }


}

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("致命的なエラー"),),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(testStreamProvider).value;
    final tests = map.docs;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(tests[index]['title']),
        );
      }, itemCount: tests.length)
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final uid = ref.read(authNotifierProvider)?.fireAuthUser?.uid;
          ref.read(testsProvider).add({
            'title': 'hogehoeg',
            'text': 'bodypiyopiyo',
            'user_id': uid,
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future setupWhenBeforeRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}