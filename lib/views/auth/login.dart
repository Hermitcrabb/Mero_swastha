import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../models/user/user_controller.dart';
import 'signup.dart';
import 'forgot.dart';
import 'verify.dart';
import '../setup/startup_screen.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Missing Info", "Email and password cannot be empty");
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      print("user: $user");
      // if (user != null && !user.emailVerified) {
      //   Get.offAll(() => const Verify());
      // } else {
      //   Get.offAll(() => const StartupScreen());
      // }

      if (user != null && !user.emailVerified) {
        Get.offAll(() => const Verify());
      } else {
        final userController = Get.find<UserController>();
        await userController.loadUser(); // ✅ Load user data from Firestore
        Get.offAll(() => const StartupScreen());
      }


    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Failed", e.message ?? "Unknown error");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Mero Swastha",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 20),
            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.to(() => const Forgot()),
                child: const Text("Forgot Password?"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () => Get.to(() => const Signup()),
                  child: const Text("Sign up"),
                )
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.toNamed('/trainer_page');
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //   ),
            //   child: const Text("View Trainers"),
            // ),
          ],
        ),
      ),
    );
  }
}
