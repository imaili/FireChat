import 'package:cloud_firestore/cloud_firestore.dart';
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
                    return SizedBox(
                      height: 400,
                      width: 400,
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (ctx, index) {
                          return Text(snapshot.data.docs[index]['text']);
                        },
                      ),
                    );
                }),
            Expanded(
              
              child: Row(
                children: [
                  TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        style: TextStyle(fontSize: 17),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide(width: 2, color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide(width: 2, color: Colors.grey)),
                        )),
                ],
              ),
                /*Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                  ),
                  child: Icon(Icons.send),
                )*/
              
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String text) {
    FirebaseFirestore.instance
        .collection('conversations')
        .doc(_conversationId)
        .collection('messages')
        .add({'text': _messageController.text});
  }
}
