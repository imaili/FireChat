import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatsScreen extends StatefulWidget {
  static const route = '/Chat-Screen';
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc('${_user.uid}')
            .collection('contacts')
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else {
            final documents = snapshot.data.documents;

            if (documents.length == 0)
              return Center(
                child: Text('Start by adding some contacts'),
              );
            else
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (ctx, index) =>
                    Text(documents[index]['contactUsername']),
                //TODO: add listview with contacts
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactSheet(context),
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddContactSheet(BuildContext ctx) {
    final _controller = TextEditingController();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        context: ctx,
        builder: (_) => Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 200 + MediaQuery.of(ctx).viewInsets.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                    ),
                    width: 40,
                    height: 4,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            labelText: 'username',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        onPressed: () => _addContact(_controller.text),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.blue,
                        child: Text(
                          'Send',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  void _addContact(String username) async {
    final contactExists = await _contactExists(username);
    final usernameExists = await _usernameExists(username);

    if (!contactExists && usernameExists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('contacts')
          .doc()
          .set({'contactUsername': username});
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Something went wrong'),
          content: Text(
              'The username you specified does not exist or is already your contact. Please try again.'),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Try again')),
          ],
        ),
      );
    }
  }

  Future<bool> _contactExists(String username) async {
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc('${_user.uid}')
        .collection('contacts')
        .where('contactUsername', isEqualTo: username)
        .get();
    return docs.docs.isNotEmpty;
  }

  Future<bool> _usernameExists(String username) async{
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return docs.docs.isNotEmpty;

  }
}
