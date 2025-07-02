import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_controller.dart';
import 'package:get/get.dart';

class logout extends StatelessWidget {
  const logout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        final userController = Get.find<UserController>();
        userController.clearUser(); // ✅ Clear cached user data
        await FirebaseAuth.instance.signOut(); // ✅ Sign out from Firebase
        Get.offAllNamed('/login'); // ✅ Navigate to login
      },
    );
  }
}