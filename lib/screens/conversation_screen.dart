import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  static const route = '/conversation';
  final String username;
  final String conversationId;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();

  ConversationScreen(this.username, this.conversationId);
  
}

class _ConversationScreenState extends State<ConversationScreen> {
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text(widget.username)),
    );
  }
}