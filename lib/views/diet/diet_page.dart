import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'diet_questions.dart';  // your questionnaire page
import 'diet_plan_result.dart'; // your diet plan result page

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to continue.")),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("User data not found.")),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;

        // Check if dietPreferences exist and are valid
        if (data == null || data['dietPreferences'] == null) {
          // No preferences saved yet -> show questionnaire
          return const DietQuestions();
        } else {
          // Show diet plan result with latest data
          return DietPlanResult(data: Map<String, dynamic>.from(data['dietPreferences']));
        }
      },
    );
  }
}
