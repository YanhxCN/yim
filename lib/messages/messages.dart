import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yim/messages/messages_data.dart';

import 'messages_item.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: messagesData.length,
        itemBuilder: (BuildContext context, int index) {
          return MessagesItem(messagesData[index]);
        }
      ),
    );
  }
}