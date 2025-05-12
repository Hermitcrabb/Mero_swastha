import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mero_swastha/forgot.dart';
import 'package:mero_swastha/signup.dart';
//import 'package:google_sign_in/google_sign_in.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isloading = false;
  //Email /password sign in
  signIn() async{
    setState(() {
      isloading = true;
    });

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
    }on FirebaseAuthException catch(e){
      Get.snackbar("Error msg", e.code);
    }catch(e){
      Get.snackbar("Error msg", e.toString());
    }
    setState(() {
      isloading = false;
    });
  }
  //Google Sign in is not working pls check
  /*Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.snackbar("Success", "Signed in with Google");
    } catch (e) {
      Get.snackbar("Google Sign-In Failed", e.toString());
    }
  }

   */

  @override
  Widget build(BuildContext context) {
    return isloading ? Center(child: CircularProgressIndicator(),) : Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),),
        body: Padding(padding: const EdgeInsets.all(20.0),
          child: Column(
          children: <Widget>[
            TextField(
              controller: email,
              decoration: InputDecoration(
                hintText: "Enter your Email address",
              ),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: "Enter your password"),
            ),

            ElevatedButton(onPressed: (()=>signIn()), child: Text("Login")),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (()=>Get.to(Signup())), child: Text("Register Now")),
            SizedBox(height:30),
            /*ElevatedButton.icon(
              onPressed: signInWithGoogle,
              icon: Icon(Icons.g_mobiledata, size: 30),
              label: Text("Sign in with Google"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),*/
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (()=>Get.to(Forgot())), child: Text("Forgot Password ?"))
            ],
          )
        )
    );
  }
}
