import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../premium/payment_gateway.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return "Guest";
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? (doc.data()?['username'] ?? 'User') : 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mero Swastha"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: fetchUserName(),
        builder: (context, snapshot) {
          final name = snapshot.data ?? '...';
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, $name 👋",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "About Mero Swastha",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Mero Swastha is your personal health companion. Track your nutrition, manage your workouts, and stay motivated with personalized features tailored to Nepali lifestyle.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                const Text(
                  "🔥 Premium Features",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: const [
                        Text(
                          "Go Premium 🚀",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "• Personalized coaching\n• Advanced workout routines\n• Motivational messages\n• In-depth progress tracking",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle premium action
                      Navigator.push(
                      context,
                          MaterialPageRoute(builder: (context) => const PaymentGatewayPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text("Upgrade to Premium"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
