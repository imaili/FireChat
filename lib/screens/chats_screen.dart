import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chat/screens/conversation_screen.dart';
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
  bool _contactsLoaded = false;
  var _contacts = List<String>();
  var _conversationsIds = List<String>();
  @override
  void initState() {
    
    _loadContacts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: _contactsLoaded ? 
            ListView.builder(
              
              itemBuilder: (ctx, index){
                return ListTile(
                  
                  enabled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  onTap: () => Navigator.of(context).pushNamed(
                    ConversationScreen.route, arguments: {'contactUsername':_contacts[index], 'conversationId': _conversationsIds[index]}),
                  leading: CircleAvatar(child: Icon(Icons.person),),
                  title: Text(_contacts[index],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                  

                );
                
              },
              itemCount: _contacts.length,
              )
           
            : CircularProgressIndicator(),

      
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
    final docRef = await FirebaseFirestore.instance
        .collection('addContactRequest')
        .add({'userId': _user.uid, 'contactUsername': username});

    FirebaseFirestore.instance
        .collection('addContactResponse')
        .doc(_user.uid)
        .snapshots()
        .listen((event) {
            if (event.data()['requestId'] == docRef.id) {
              if (!event.data()['done']) {
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
                        ));
                return;
              }
              else{
                Navigator.of(context).pop();
                return;
              }
            }
        });

    
  }

  void _loadContacts() async {
    final snap = await FirebaseFirestore.instance.collection('users/${_user.uid}/contacts').get();
    
    snap.docs.forEach((doc) {
      _contacts.add(doc['contactUsername']);
      _conversationsIds.add(doc['conversationId']);
    });
    setState(() {
          _contactsLoaded = true;
    });
  }




}


