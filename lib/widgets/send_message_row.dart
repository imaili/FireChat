import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendMessageRow extends StatefulWidget {
  final _conversationId;

  SendMessageRow(this._conversationId);
  @override
  _SendMessageRowState createState() => _SendMessageRowState();
}

class _SendMessageRowState extends State<SendMessageRow> {
  String _message = '';
  final _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                style: TextStyle(fontSize: 18),
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

                ),
                onChanged: (value) {
                    _message = value;
                },

              ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _sendMessage(_message))
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget._conversationId)
        .collection('messages')
        .add({'text': text, 
              'sentBy' : FirebaseAuth.instance.currentUser.email.split('@')[0], 
              'createdAt': Timestamp.now()});
        _controller.clear();
        
  }
}
