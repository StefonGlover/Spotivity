import 'dart:ui';
import 'package:spotivity/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController textFieldController = TextEditingController();
  DateTime dateTime = DateTime.now();

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
      body: Container(),
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
