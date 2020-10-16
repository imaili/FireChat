import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({
    Key key,
    @required String conversationId,
  })  : _conversationId = conversationId,
        super(key: key);

  final String _conversationId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .doc(_conversationId)
            .collection('messages')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (ctx, index) {
                return Text(snapshot.data.docs[index]['text']);
              },
            );
        });
  }
}
