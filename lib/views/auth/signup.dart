import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'verify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}
class Debouncer{
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay});

  run(VoidCallback action){
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
  void dispose(){
    _timer?.cancel();
  }
}


class _SignupState extends State<Signup> {
  @override
  void initState() {
    super.initState();

    // Add your username availability listener here
    userNameController.addListener(_checkUsernameAvailability);
  }
  final _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isUsernameAvailable =false;
  String usernameStatusMessage='';

  bool isLoading = false;

  void signup() async {

    final user = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (user.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      // 🔍 Check if username is already taken
      final usernameExists = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: user)
          .get();

      if (usernameExists.docs.isNotEmpty) {
        Get.snackbar("Error", "Username already taken");
        setState(() => isLoading = false);
        return;
      }

      // ✅ Create the user in Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 📝 Save username & email to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': user,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 🚀 Navigate to verification screen
      Get.offAll(() => const Verify());

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Failed", e.message ?? "Unknown error");
    }

    setState(() => isLoading = false);
  }
  void _checkUsernameAvailability() {
    final username = userNameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        usernameStatusMessage = '';
        isUsernameAvailable = false;
      });
      return;
    }

    _debouncer.run(() async {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      setState(() {
        isUsernameAvailable = query.docs.isEmpty;
        usernameStatusMessage = isUsernameAvailable
            ? "✅ Username available"
            : "❌ Username already taken";
      });
    });
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
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height:50),
            const Text("UserName", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                hintText: 'Enter your username',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              usernameStatusMessage,
              style: TextStyle(
                color: isUsernameAvailable ? Colors.green : Colors.red,fontSize: 13,)
            ),
            const SizedBox(height: 20),
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
                hintText: 'Create a password',
              ),
            ),
            const SizedBox(height: 20),
            const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                hintText: 'Re-enter your password',
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Sign up", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () => Get.to(() => const Login()),
                  child: const Text("Login"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    userNameController.removeListener(_checkUsernameAvailability);
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}