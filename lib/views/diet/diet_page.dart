import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'diet_questions.dart';
import 'diet_plan_result.dart';
import 'food_product.dart';

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

        if (data == null || data['dietPreferences'] == null) {
          return const DietQuestions();
        }

        final preferences = Map<String, dynamic>.from(data['dietPreferences']);
        final cachedPlan = data['generatedDietPlan'] as Map<String, dynamic>?;

        if (cachedPlan != null && cachedPlan.isNotEmpty) {
          // ✅ Pass cached diet plan to the result page
          return DietPlanResult(
            data: preferences,
            cachedMealPlan: _convertStoredPlanToMap(cachedPlan),
          );
        } else {
          // No cache yet → regenerate
          return DietPlanResult(data: preferences);
        }
      },
    );
  }

  /// 🔄 Helper: Convert raw Firestore map to proper Map<String, List<FoodProduct>>
  Map<String, List<FoodProduct>> _convertStoredPlanToMap(Map<String, dynamic> raw) {
    final Map<String, List<FoodProduct>> result = {};

    raw.forEach((mealName, productList) {
      final products = (productList as List<dynamic>).map((p) {
        return FoodProduct(
          name: p['name'] ?? 'Unnamed',
          calories: (p['calories'] as num).toDouble(),
          protein: (p['protein'] as num).toDouble(),
          fat: (p['fat'] as num).toDouble(),
          carbs: (p['carbs'] as num).toDouble(),
        );
      }).toList();
      result[mealName] = products;
    });

    return result;
  }
}
