import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  String message;
  String timeSent;
  bool sentBy;

  MessageLayout(this.message, this.timeSent, this.sentBy);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentBy ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomRight: sentBy
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: sentBy
                      ? const Radius.circular(24)
                      : const Radius.circular(0)),
              color: sentBy ? Colors.blue : Colors.grey[900]),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(color: sentBy ? Colors.black : Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }
}
