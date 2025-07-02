import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_product_service.dart';
import 'food_product.dart';

class MealPlanGenerator {
  static const Map<String, List<String>> mealStapleMap = {
    'Breakfast': [
      "Milk",
      "Yogurt",
      "Roti",
      "Egg",
      "Paneer",
      "Soybean",
      "Green Leafy Veggies"
    ],
    'Lunch': [
      "Rice",
      "Dal",
      "Vegetables",
      "Curry",
      "Pickle",
      "Chicken",
      "Paneer",
      "Buff Meat"
    ],
    'Dinner': [
      "Roti",
      "Dal",
      "Vegetables",
      "Curry",
      "Fish",
      "Mushroom",
      "Paneer",
      "Soybean"
    ],
    'Snacks': [
      "Milk",
      "Yogurt",
      "Pickle",
      "Paneer",
      "Egg",
      "Beans",
      "Green Leafy Veggies"
    ]
  };

  static Future<Map<String, List<FoodProduct>>> generateMealPlan(
      List<String> mealLabels,
      List<String> userStaples,
      String dietType,
      double caloriesPerMeal,
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    Map<String, List<FoodProduct>> mealPlan = {};

    for (final label in mealLabels) {
      final validStaples = mealStapleMap[label]!
          .where((food) => userStaples.contains(food))
          .toList();

      final fetched = await FoodProductService.fetchProductsByStapleAndDiet(
          validStaples, dietType);
      final selected = FoodProductService.selectProductsForMeal(fetched, caloriesPerMeal);

      mealPlan[label] = selected;
    }

    // Save to Firestore
    final fireMap = mealPlan.map((key, products) => MapEntry(key, products.map((p) => p.toJson()).toList()));

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'generatedDietPlan': fireMap,
      'dietPreferences.lastGenerated': FieldValue.serverTimestamp(),
    });

    return mealPlan;
  }
}
