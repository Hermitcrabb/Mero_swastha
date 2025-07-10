import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/food_product_service.dart';
import 'products/food_product.dart';
import 'products/meal_catagory.dart';
import 'products/meal_item.dart';
import 'services/meal_data_loader.dart';

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

    final MealCategory localMeals = await loadLocalMealData();
    final Map<String, List<FoodProduct>> mealPlan = {};

    for (final label in mealLabels) {
      final staplesForMeal = mealStapleMap[label]!;
      final lowerUserStaples = userStaples.map((s) => s.toLowerCase()).toList();
      final userRelevantStaples = staplesForMeal
          .where((s) => lowerUserStaples.contains(s.toLowerCase()))
          .toList();
      print("For $label → matched staples: $userRelevantStaples");

      // Match local meals containing staple
      final List<MealItem> localMealList = switch (label) {
        'Breakfast' => localMeals.breakfast,
        'Lunch' => localMeals.lunch,
        'Dinner' => localMeals.dinner,
        'Snacks' => localMeals.snacks,
        _ => [],
      };

      // Try finding meals from local JSON that use one of the user's staple foods
      final List<MealItem> localMatching = localMealList
          .where((meal) => userRelevantStaples.any((staple) => meal.name.toLowerCase().contains(staple.toLowerCase())))
          .toList();

      if (localMatching.isNotEmpty) {
        // If local meals are found, convert to FoodProducts first
        final localProducts = localMatching.map((m) => FoodProduct(
          name: m.name,
          calories: m.calories.toDouble(),
          protein: m.protein.toDouble(),
          fat: m.fat.toDouble(),
          carbs: m.carbs.toDouble(),
        )).toList();

        // Then apply calorie-limiting selection logic
        final selected = FoodProductService.selectProductsForMeal(localProducts, caloriesPerMeal);
        mealPlan[label] = selected;
      } else {
        // If no local meals found, fallback to Open Food Facts API
        final fetched = await FoodProductService.fetchProductsByStapleAndDiet(userRelevantStaples, dietType);
        final selected = FoodProductService.selectProductsForMeal(fetched, caloriesPerMeal);
        mealPlan[label] = selected;
      }
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


//old code
  //
  // static Future<Map<String, List<FoodProduct>>> generateMealPlan(
  //     List<String> mealLabels,
  //     List<String> userStaples,
  //     String dietType,
  //     double caloriesPerMeal,
  //     ) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return {};
  //
  //   Map<String, List<FoodProduct>> mealPlan = {};
  //
  //   for (final label in mealLabels) {
  //     final validStaples = mealStapleMap[label]!
  //         .where((food) => userStaples.contains(food))
  //         .toList();
  //
  //     final fetched = await FoodProductService.fetchProductsByStapleAndDiet(
  //         validStaples, dietType);
  //     final selected = FoodProductService.selectProductsForMeal(fetched, caloriesPerMeal);
  //
  //     mealPlan[label] = selected;
  //   }
//
//     // Save to Firestore
//     final fireMap = mealPlan.map((key, products) => MapEntry(key, products.map((p) => p.toJson()).toList()));
//
//     await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//       'generatedDietPlan': fireMap,
//       'dietPreferences.lastGenerated': FieldValue.serverTimestamp(),
//     });
//
//     return mealPlan;
//   }
// }
