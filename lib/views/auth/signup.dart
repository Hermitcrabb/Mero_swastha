import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'verify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  final numberRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{5,}$');
  return numberRegex.hasMatch(password);
}

class _SignupState extends State<Signup> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;
  bool isLoading = false;

  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      final email = emailController.text.trim();
      setState(() {
        isEmailValid = isValidEmail(email);
        emailError = isEmailValid ? null : 'Invalid email address or format';
      });
    });

    passwordController.addListener(() {
      final password = passwordController.text.trim();
      setState(() {
        isPasswordValid = isValidPassword(password);
        passwordError = isPasswordValid ? null : 'Password must be at least 5 characters and contain letters and numbers';
      });
    });

    confirmPasswordController.addListener(() {
      setState(() {
        isConfirmPasswordValid = confirmPasswordController.text.trim() == passwordController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() async {
    final user = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (user.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (!isEmailValid) {
      Get.snackbar("Error", "Invalid email address");
      return;
    }

    if (!isValidPassword(password)) {
      Get.snackbar("Error", "Password must contain letters and numbers");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Create user in Firebase Authentication
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user data to Firestore under their UID
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': user,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => isLoading = false);
      }

      // Navigate to verify screen
      Get.offAll(() => const Verify());
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      Get.snackbar("Signup Failed", e.message ?? "Unknown error");
    }
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
            const SizedBox(height: 50),
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
            const SizedBox(height: 10),
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              emailError ?? "",
              style: TextStyle(
                color: emailError == null ? Colors.green : Colors.red,
                fontSize: 13,
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
            const SizedBox(height: 4),
            Text(
              passwordError ?? "",
              style: TextStyle(
                color: passwordError == null ? Colors.green : Colors.red,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            const Text("Confirm Password", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                hintText: 'Re-enter your password',
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isEmailValid && isPasswordValid && isConfirmPasswordValid && !isLoading)
                    ? signup
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign up", style: TextStyle(fontSize: 18)),
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
}
