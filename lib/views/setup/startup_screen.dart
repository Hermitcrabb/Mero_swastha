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

    final user = FirebaseAuth.instance.currentUser;

    return Obx(() {
      // Still show loading if userModel is null but user is logged in
      if (user != null && userController.userModel.value == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

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
    });
  }
}
