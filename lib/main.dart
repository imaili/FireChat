import 'package:fire_chat/screens/chats_screen.dart';
import 'package:fire_chat/screens/conversation_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              
              theme: ThemeData(
                
                primarySwatch: Colors.blue,
                accentColor: Colors.white,
                textTheme: TextTheme(headline2: TextStyle(color: Colors.blue)),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: FirebaseAuth.instance.currentUser == null ? AuthScreen() : ChatsScreen(),

             
              routes: {
                AuthScreen.route: (ctx) => AuthScreen(),
                ChatsScreen.route: (ctx) => ChatsScreen(),
                ConversationScreen.route: (ctx) => ConversationScreen(),

              },
            );
          }
          else
            return CircularProgressIndicator();
        });
  }
}
