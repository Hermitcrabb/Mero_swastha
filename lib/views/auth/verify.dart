import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../setup/startup_screen.dart';
import 'login.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isLoading = false;

  void sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        Get.snackbar(
          "Email Sent",
          "Verification email has been sent to ${user.email}",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
      } catch (e) {
        Get.snackbar("Error", "Could not send email. Try again later.");
      }
    } else {
      Get.snackbar("Error", "User not found or already verified");
    }
  }
  @override
  void initState() {
    super.initState();
    // Automatically send verification email on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendVerifyLink();
    });
  }

  void reloadAndCheck() async {
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser != null && updatedUser.emailVerified) {
        Get.offAll(() => const StartupScreen());
      } else {
        Get.snackbar(
          "Still Not Verified",
          "Please check your email and click the link.",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Try again.");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text(
                'A verification email has been sent to your registered email address.\n\nPlease check your inbox or spam folder.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: sendVerifyLink,
                icon: const Icon(Icons.send),
                label: const Text("Resend Email"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: reloadAndCheck,
                icon: const Icon(Icons.refresh),
                label: const Text("Reload and Continue"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear user session here if needed
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                        (route) => false,
                  );
                },
                child: Text('Logout'),
              )

            ],
          ),
        ),
      ),
    );
  }
}
