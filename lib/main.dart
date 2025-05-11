import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Your app startup code
  runApp(MeroSwastha());
}

class MeroSwastha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mero Swastha',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Mero Swastha'),
        ),
        body: Center(child: Text('Hello, World!')),
      ),
    );
  }
}