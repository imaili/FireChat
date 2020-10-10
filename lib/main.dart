import 'package:fire_chat/screens/chats_screen.dart';
import 'package:fire_chat/screens/conversation_screen.dart';
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
              home: ChatsScreen(),

              onGenerateRoute: (settings) {
                  if (settings.name == ConversationScreen.route) {
                    final arguments = settings.arguments as Map<String, String>;
                    final username = arguments['username'];
                    final conversationId = arguments['conversationId'];
                    // Then, extract the required data from the arguments and
                    // pass the data to the correct screen.
                    return MaterialPageRoute(
                      builder: (context) {
                        return ConversationScreen(username, conversationId);
                      });
                  }
              },

              routes: {
                AuthScreen.route: (ctx) => AuthScreen(),
                ChatsScreen.route: (ctx) => ChatsScreen(),

              },
            );
          }
          else
            return CircularProgressIndicator();
        });
  }
}
