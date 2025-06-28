import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../auth/login.dart';
import 'profile_setup.dart';
import '../../homepage.dart';
import '../models/user_model.dart';
import '../models/user_controller.dart';
import '../auth/verify.dart';
class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return FutureBuilder(
      future: userController.fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return const Login(); // Not logged in
        }

        if (!user.emailVerified) {
          return const Verify(); // Not verified
        }

        if (userController.userModel.value == null || userController.userModel.value!.name.isEmpty) {
          return const ProfileSetupPage(); // Profile missing
        }

        return const Homepage(); // All set up
      },
    );
  }
}
