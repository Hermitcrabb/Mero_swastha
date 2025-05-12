import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'login.dart';
import 'verify.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          } if (snapshot.hasData) {
            final user = snapshot.data!;
            print(user);
            if (snapshot.data!.emailVerified){
              return const Homepage();
            }
            else{
              return const Verify();
            }
          }
          else {
            return const Login();
          }
        },
      ),
    );
  }
}

