import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotivity/controllers/player_controller.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotivity/stagger_animation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController animationController;
  late SpotifyController spotifyController;
  late PlayerController playerController;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    spotifyController = Get.put(SpotifyController(this));
    playerController = Get.put(PlayerController(this));
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey,
          actions: [
            FloatingActionButton(
              backgroundColor: Colors.red.shade400,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: const Text(
                            'Are you sure you want to log out?',
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red.shade800)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'NO',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green.shade800)),
                                onPressed: () {
                                  _signOut(context);
                                },
                                child: const Text(
                                  'YES',
                                  style: TextStyle(fontSize: 20),
                                ))
                          ]);
                    });
              },
              tooltip: 'Log Out',
              child: const Icon(
                Icons.logout,
              ),
            )
          ]),
      body: StaggerAnimation(
          controller: animationController,
          spotifyController: spotifyController,
          playerController: playerController,
          textEditingController: textEditingController),
    );
  }

  void _signOut(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    await _auth.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('User logged out.')));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (con) => AppDriver()));
  }
}
