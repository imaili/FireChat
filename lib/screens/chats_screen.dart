import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatsScreen extends StatefulWidget {
  
  static const route = '/Chat-Screen';
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final user = args['user'] as User;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        
      ),
      
    );
  }
}