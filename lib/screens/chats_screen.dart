import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

      body: FutureBuilder(
        
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).collection('contacts').get(),
        builder: (ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
            
            
          else{ 
            final documents = snapshot.data.documents;     
            if(documents.length == 0)
              return Center(child: Text('Start by adding some contacts'),);
            else return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (ctx, index) => Text(documents[index]['contactUsername']),
              //TODO: add listview with contacts
            );
          }

        
        },
        
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContact,
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      
    );
  }
  void _addNewContact(){}
}