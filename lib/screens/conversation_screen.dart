import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chat/widgets/send_message_row.dart';
import '../widgets/messages_list.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  static final String route = '/conversation-screen';
  String _username;
  String _conversationId;
  TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    _username = args['contactUsername'];
    _conversationId = args['conversationId'];
    print(_conversationId);

    return Scaffold(
      appBar: AppBar(title: Text(_username)),
     
      body: Container(
              child: Column(
          children: [
            Expanded(child: MessagesList(conversationId: _conversationId)),
            SendMessageRow(_conversationId),
            
          ]
            
        ),
      ),
    );
  }


}

