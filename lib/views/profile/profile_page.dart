import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user/user_controller.dart';
import '../setup/trainer/trainer_profile_setup_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userController = Get.find<UserController>();

  // Trainer signup eligibility
  bool _canSignup = false;
  bool _checkingEligibility = true;

  // Admin role check
  bool _isAdmin = false;
  bool _checkingAdmin = true;

  @override
  void initState() {
    super.initState();
    checkSignupEligibility();
    checkAdminStatus();
  }

  Future<void> checkSignupEligibility() async {
    final allowed = await canUserSignupAsTrainer();
    if (mounted) {
      setState(() {
        _canSignup = allowed;
        _checkingEligibility = false;
      });
    }
  }

  Future<bool> canUserSignupAsTrainer() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final uid = user.uid;

    final appDoc = await FirebaseFirestore.instance
        .collection('trainer_applications')
        .doc(uid)
        .get();

    if (appDoc.exists) return false;

    final trainerDoc = await FirebaseFirestore.instance
        .collection('trainers')
        .doc(uid)
        .get();

    if (trainerDoc.exists) return false;

    return true;
  }

  Future<void> checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() {
          _isAdmin = false;
          _checkingAdmin = false;
        });
      }
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (mounted) {
      setState(() {
        _isAdmin = doc.exists && doc.data()?['role'] == 'admin';
        _checkingAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final user = userController.userModel.value;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final name = user.name.isNotEmpty ? user.name : "User";
          final email = user.email.isNotEmpty ? user.email : "Email not found";
          final gender = user.gender.isNotEmpty ? user.gender : "N/A";
          final age = user.age > 0 ? user.age.toString() : "N/A";
          final height = user.height > 0 ? user.height.toString() : "N/A";
          final weight = user.weight > 0 ? user.weight.toString() : "N/A";
          final activity =
          user.activityLevel.isNotEmpty ? user.activityLevel : "N/A";

          return Column(
            children: [
              // Avatar and name
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 10),
              Text(name, style: Theme.of(context).textTheme.titleLarge),
              Text(email, style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: 30),

              // Health Profile card
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
                padding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                        _coloredStatTile(
                            "Activity", activity, Colors.deepPurpleAccent),
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

              // Edit profile button
              OutlinedButton.icon(
                onPressed: () {
                  Get.toNamed('/profile_setup');
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.deepPurple),
                  foregroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Signup as Trainer button
              _checkingEligibility
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                onPressed: _canSignup
                    ? () => Get.toNamed('/trainer_signup_page')
                    : null,
                icon: const Icon(Icons.app_registration),
                label: const Text("Signup as Trainer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _canSignup ? Colors.deepPurple : Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 24),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              if (!_canSignup && !_checkingEligibility)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "You have already applied or are registered as a trainer.",
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),

              // Show Admin Approval button ONLY if user is admin and not loading admin check
              if (!_checkingAdmin && _isAdmin)
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/admin_trainer_approval_page');
                  },
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("Admin Approval Test"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Trainer Profile Setup Test Button
              ElevatedButton.icon(
                onPressed: () {
                  print("Navigating to trainer setup...");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TrainerProfileSetupPage()),
                  );
                },
                icon: const Icon(Icons.app_registration),
                label: const Text("Trainer Profile Setup Test"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          );
        }),
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
