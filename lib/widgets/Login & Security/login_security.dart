import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotivity/views/chat_room_view.dart';
import 'package:spotivity/widgets/Login%20&%20Security/delete_account_alert.dart';
import 'package:spotivity/widgets/Login%20&%20Security/reset_password.dart';

class LoginAndSecurity extends StatefulWidget {
  const LoginAndSecurity({Key? key}) : super(key: key);

  @override
  State<LoginAndSecurity> createState() => _LoginAndSecurityState();
}

class _LoginAndSecurityState extends State<LoginAndSecurity> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height:80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GestureDetector(
                      onTap: null,
                      child: ListTile(
                        title: const Text(
                          'Name:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['firstName'] + " " + data['lastName'],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height:80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GestureDetector(
                      onTap: null,
                      child: ListTile(
                        title: const Text(
                          'Email:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          FirebaseAuth.instance.currentUser!.email!,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height:80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GestureDetector(
                      onTap: null,
                      child: ListTile(
                        title: const Text(
                          'Password:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "********",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Container(
                          color: Colors.grey[900],
                          width: 65,
                          child:IconButton(
                            onPressed: () {
                             resetPasswordDialog(context);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height:80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GestureDetector(
                      onTap: null,
                      child: ListTile(
                        title: const Text(
                          'Message:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "Contact customer service ",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Container(
                          width: 65,
                          color: Colors.grey[900],
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoomPage()));
                            },
                            icon: const Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height:80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: GestureDetector(
                      onTap: null,
                      child: ListTile(
                        title: const Text(
                          'Delete Account:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "Permanently delete your account and all data ",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Container(
                          width: 65,
                          color: Colors.grey[900],
                          child: IconButton(
                            onPressed: () {
                             accountDeleteAlert(context);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
