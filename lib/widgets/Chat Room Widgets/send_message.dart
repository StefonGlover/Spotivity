import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:spotivity/Helpers/chat_functions.dart';

class SendMessage extends StatelessWidget {

  String chatRoomID, friendUID;

  SendMessage({Key? key, required this.chatRoomID, required this.friendUID}) : super(key: key);

  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return;
                }
              },
              autocorrect: false,
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Message',
                  isDense: true,
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),

                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20))),
            )),
        IconButton(
            onPressed: () async
            {
              if(_messageController.text.isNotEmpty)
              {
                ChatFunctions().createChatRoomAndStartConversation(friendUID);
                ChatFunctions().sendMessage(chatRoomID, _messageController.text, friendUID);
                _messageController.clear();
              }
            },
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ))
      ],
    );
  }}