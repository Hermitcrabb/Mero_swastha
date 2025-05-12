import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mero_swastha/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signup() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
    Get.offAll(Wrapper());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup"),),
        body: Padding(padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    hintText: "Enter your Email address",
                  ),
                ),
                TextField(
                  controller: password,
                  decoration: const InputDecoration(hintText: "Enter your password"),
                ),

                ElevatedButton(onPressed: (()=>signup()), child: const Text("Login"))
              ],
            )
        )
    );
  }
}
