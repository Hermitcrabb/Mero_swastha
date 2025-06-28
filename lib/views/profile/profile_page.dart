import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_controller.dart';

class ProfilePage extends StatelessWidget {
  final userController = Get.find<UserController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = userController.userModel.value;
    final name = user?.name ?? "User";
    final email = user?.email ?? "Email not found";
    final gender = user?.gender ?? "N/A";
    final age = user?.age.toString() ?? "N/A";
    final height = user?.height.toString() ?? "N/A";
    final weight = user?.weight.toString() ?? "N/A";
    final activity = user?.activityLevel ?? "N/A";

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Name
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 40, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 10),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            Text(email, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 30),

            // Enhanced Health Profile Card
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade100.withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Health Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple.shade700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _coloredStatTile("Age", age, Colors.deepPurple),
                      _coloredStatTile("Gender", gender, Colors.purpleAccent),
                      _coloredStatTile("Activity", activity, Colors.deepPurpleAccent),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _coloredStatTile("Height", "$height cm", Colors.indigo),
                      _coloredStatTile("Weight", "$weight kg", Colors.deepPurple),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Edit Profile Button
            OutlinedButton.icon(
              onPressed: () {
                Get.toNamed('/profile-setup');
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.deepPurple),
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coloredStatTile(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.deepPurple.shade300,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
