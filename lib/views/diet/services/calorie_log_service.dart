import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../products/food_product.dart';

class CalorieLogService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  /// Logs a meal into today's calorie log in Firestore.
  static Future<void> logMealForToday(String mealName, List<FoodProduct> foods) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final today = DateTime.now();
    final docId = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final mealMap = {
      'name': mealName,
      'foods': foods.map((f) => f.toJson()).toList(),
    };

    // Calculate meal macros
    double totalCalories = 0, totalProtein = 0, totalFat = 0, totalCarbs = 0;
    for (var food in foods) {
      totalCalories += food.calories;
      totalProtein += food.protein;
      totalFat += food.fat;
      totalCarbs += food.carbs;
    }

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('calorieLogs')
        .doc(docId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        // Update totals
        final updatedCalories = (data['totalCalories'] ?? 0) + totalCalories;
        final updatedProtein = (data['totalProtein'] ?? 0) + totalProtein;
        final updatedFat = (data['totalFat'] ?? 0) + totalFat;
        final updatedCarbs = (data['totalCarbs'] ?? 0) + totalCarbs;

        // Append to meals list
        final List<dynamic> existingMeals = data['meals'] ?? [];
        existingMeals.add(mealMap);

        transaction.update(docRef, {
          'totalCalories': updatedCalories,
          'totalProtein': updatedProtein,
          'totalFat': updatedFat,
          'totalCarbs': updatedCarbs,
          'meals': existingMeals,
        });
      } else {
        // Create new document
        transaction.set(docRef, {
          'totalCalories': totalCalories,
          'totalProtein': totalProtein,
          'totalFat': totalFat,
          'totalCarbs': totalCarbs,
          'meals': [mealMap],
        });
      }
    });
  }

  /// Fetch today's calorie log.
  static Future<Map<String, dynamic>?> fetchTodayCalorieLog() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final today = DateTime.now();
    final docId = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('calorieLogs')
        .doc(docId)
        .get();

    if (doc.exists) {
      return doc.data();
    }

    return null;
  }

  /// OPTIONAL: Delete a logged meal (for future edit feature)
  static Future<void> deleteMealFromToday(String mealName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final today = DateTime.now();
    final docId = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('calorieLogs')
        .doc(docId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final meals = List<Map<String, dynamic>>.from(data['meals'] ?? []);

        // Find and remove the meal
        final mealToRemove = meals.firstWhere((m) => m['name'] == mealName, orElse: () => {});
        if (mealToRemove.isEmpty) return;

        meals.remove(mealToRemove);

        // Recalculate totals
        double totalCalories = 0, totalProtein = 0, totalFat = 0, totalCarbs = 0;
        for (var meal in meals) {
          for (var food in meal['foods']) {
            totalCalories += food['calories'] ?? 0;
            totalProtein += food['protein'] ?? 0;
            totalFat += food['fat'] ?? 0;
            totalCarbs += food['carbs'] ?? 0;
          }
        }

        transaction.update(docRef, {
          'totalCalories': totalCalories,
          'totalProtein': totalProtein,
          'totalFat': totalFat,
          'totalCarbs': totalCarbs,
          'meals': meals,
        });
      }
    });
  }
  static Future<void> removeFoodFromToday(String mealName, FoodProduct food) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final docId = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('calorieLogs')
        .doc(docId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final meals = List<Map<String, dynamic>>.from(data['meals'] ?? []);

      for (int i = 0; i < meals.length; i++) {
        if (meals[i]['name'] == mealName) {
          final foods = List<Map<String, dynamic>>.from(meals[i]['foods'] ?? []);
          foods.removeWhere((f) => f['name'] == food.name);

          // Update meal foods
          meals[i]['foods'] = foods;

          // Adjust totals
          data['totalCalories'] = (data['totalCalories'] ?? 0) - food.calories;
          data['totalProtein'] = (data['totalProtein'] ?? 0) - food.protein;
          data['totalFat'] = (data['totalFat'] ?? 0) - food.fat;
          data['totalCarbs'] = (data['totalCarbs'] ?? 0) - food.carbs;

          break;
        }
      }

      // Remove meal if empty
      meals.removeWhere((meal) => (meal['foods'] as List).isEmpty);

      transaction.update(docRef, {
        'totalCalories': data['totalCalories'],
        'totalProtein': data['totalProtein'],
        'totalFat': data['totalFat'],
        'totalCarbs': data['totalCarbs'],
        'meals': meals,
      });
    });
  }


}
