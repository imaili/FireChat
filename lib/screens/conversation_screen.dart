import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  static final String route = '/conversation-screen';
  String _username;
  String _conversationId;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    _username = args['contactUsername'];
    _conversationId = args['conversationId'];
    print(_conversationId);

    return Scaffold(
      appBar: AppBar(title: Text(_username)),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(_conversationId)
                  .collection('messages')
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                else
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (ctx, index) {
                        return Text(snapshot.data.docs[index]['text']);
                      },
                    ),
                  );
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: TextField(
              decoration: InputDecoration(
                  
                  contentPadding: EdgeInsets.all(5),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Type a message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(width: 2, color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide(width: 2, color: Colors.grey)),                  )
                ),
                  
                      
            ),
          
        ],
      ),
    );
  }
}
