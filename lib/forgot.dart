import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  TextEditingController email = TextEditingController();


  reset() async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),),
        body: Padding(padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    hintText: "Enter your Email address",
                  ),
                ),

                ElevatedButton(onPressed: (()=>reset()), child: const Text("Send Reset Link"))
              ],
            )
        )
    );
  }
}
