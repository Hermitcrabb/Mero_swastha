import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mero_swastha/wrapper.dart';
//TODO:Check if the user is verified or not if they are old user before this update
class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sendVerifyLink();
  }

  void sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    Get.snackbar(
      "Email Sent",
      "Please verify your email",
      margin: const EdgeInsets.all(10),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void reloadAndCheck() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.currentUser!.reload();
    final updatedUser = FirebaseAuth.instance.currentUser;

    setState(() {
      isLoading = false;
    });

    if (updatedUser != null && updatedUser.emailVerified) {
      Get.offAll(() => const Wrapper());
    } else {
      Get.snackbar(
        "Still not verified",
        "Please check your email and click the verification link.",
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text(
            'Check your email and click the verification link.\nThen press the reload button.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reloadAndCheck,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
