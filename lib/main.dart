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
              home: AuthScreen(),
            );
          }
          else
            return CircularProgressIndicator();
        });
  }
}
