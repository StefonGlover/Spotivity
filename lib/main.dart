/*
This program was adapated from R. Dias's flutter_music_player

(Source: https://github.com/rod90ad/flutter_music_player)
*/

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:spotivity/driver.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SomethingWentWrong();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return AppDriver();
            } else {
              return Container(color: Colors.yellow);
            }
          },
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
    );
  }
}
