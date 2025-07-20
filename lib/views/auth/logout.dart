import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user/user_controller.dart';
import 'package:get/get.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        final userController = Get.find<UserController>();
        userController.clearUser(); // ✅ Clear user data from memory
        await FirebaseAuth.instance.signOut(); // ✅ Sign out from Firebase

        Get.snackbar(
          "Logged Out",
          "You have been logged out successfully.",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed('/login'); // ✅ Navigate to login page
      },
    );
  }
}
