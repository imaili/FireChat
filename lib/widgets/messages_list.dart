import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

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
                return Bubble(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    child: Text(snapshot.data.docs[index]['text'], textAlign: TextAlign.left,)),
                  alignment: Alignment.centerRight,
                  margin: BubbleEdges.only(left: 60, top: 10, right: 7),
                  color: Color.fromRGBO(43, 184, 255, 1),   
                  nip: BubbleNip.rightTop,
                  elevation: 2,


                  
                  
                );
              },
            );
        });
  }
}
