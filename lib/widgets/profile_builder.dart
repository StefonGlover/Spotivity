import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotivity/Helpers/validation_methods.dart';
import 'package:spotivity/main.dart';

import 'delete_account_alert.dart';

class ProfileBuilder extends StatefulWidget {
  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Account',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
          ],
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              final data = snapshot.requireData;

              return Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.all(10),
                child: Card(
                  child: Container(
                    height: 300,
                    width: 400,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          ValidationMethods().greeting(data['firstName']),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          maxRadius: 70,
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(data['profilePic']),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Date joined: ' +
                               data['dateRegistered']
                                    .toDate()
                                    .toString()
                                    .substring(0, 10),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            )),
                        ButtonBar(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await accountDeleteAlert(context);

                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                )),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
