import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mero_swastha/wrapper.dart';

void main() async{
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Your app startup code
  runApp(MeroSwastha());
}

class MeroSwastha extends StatelessWidget {
  const MeroSwastha({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mero Swastha',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Mero Swastha'),
        ),
        body: Wrapper(),
      ),
    );
  }
}