import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'User';

    return Container(
      color: const Color(0xFFF3F4F6),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "👋 Welcome, $userName",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Start your fitness journey today!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Track your BMI, follow workout routines, and get customized diet plans. Upgrade to premium to unlock more features!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              _featureCard(
                title: "🏋️ Personalized Workouts",
                description: "Daily workout routines tailored to your fitness goals.",
                backgroundColor: Colors.deepPurple.shade50,
              ),
              const SizedBox(height: 16),
              _featureCard(
                title: "🥗 Smart Diet Plans",
                description: "Affordable, nutritious meals based on Nepali cuisine.",
                backgroundColor: Colors.green.shade50,
              ),
              const SizedBox(height: 16),
              _featureCard(
                title: "📊 BMI & Progress Tracking",
                description: "Monitor your physical progress and stay motivated.",
                backgroundColor: Colors.orange.shade50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard({
    required String title,
    required String description,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
