import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spotivity/Helpers/authentication.dart';
import 'package:spotivity/controllers/player_controller.dart';
import 'package:spotivity/controllers/spotify_controller.dart';
import 'package:spotivity/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotivity/stagger_animation.dart';
import 'package:spotivity/views/login_view.dart';
import 'package:spotivity/widgets/profile_builder.dart';

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
        title: const Text('Spotivity',
            style: TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.grey[900],
                title: const Text('Log out',
                    style: TextStyle(color: Colors.white)),
                content: const Text('Are you sure you want to log out?',
                    style: TextStyle(color: Colors.white)),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => _signOut(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Authentication().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            child: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
          TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileBuilder())),
              child: const Icon(Icons.person, color: Colors.white))
        ],
      ),
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
