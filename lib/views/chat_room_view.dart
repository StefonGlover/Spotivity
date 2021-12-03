import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotivity/Helpers/chat_functions.dart';
import 'package:spotivity/widgets/Chat%20Room%20Widgets/conversation.dart';
import 'package:spotivity/widgets/Chat%20Room%20Widgets/send_message.dart';

class ChatRoomPage extends StatefulWidget {
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  String chatRoomID = ChatFunctions().getChatRoomId('spotivity', FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)))),
          home: Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Column(
                children: const [
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage("images/vinyl.png"),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Spotivity',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
              backgroundColor: Colors.grey[900],
            ),
            body: Column(
              children: <Widget>[
                Flexible(
                    flex: 9,
                    child: Column(
                      children: [Conversation(chatRoomID: chatRoomID)],
                    )),
                Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[900],
                      height: double.infinity,
                      child: SendMessage(
                          chatRoomID: chatRoomID!,
                          friendUID: 'spotivity'),
                    )),
              ],
            ),
          ));
    }
  }
  
