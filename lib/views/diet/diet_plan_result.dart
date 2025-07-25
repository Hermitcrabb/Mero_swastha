import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'calorie_intake_calculate.dart';
import 'products/food_product.dart';
import 'meal_plan_generator.dart';
// import 'edit_meal_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_meal_page/edit_meal_page.dart';
import 'services/calorie_log_service.dart';
import 'services/calorie_tracking_feature/calorie_tracker_page.dart';

class DietPlanResult extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, List<FoodProduct>>? cachedMealPlan;

  const DietPlanResult({super.key, required this.data, this.cachedMealPlan});

  @override
  State<DietPlanResult> createState() => _DietPlanResultState();
}

class _DietPlanResultState extends State<DietPlanResult> {
  Map<String, dynamic>? todayCalorieLog;
  bool isLoadingLog = true;
  Map<String, Set<String>> loggedFoods = {}; // MealName -> Set of Food Names

  @override
  void initState() {
    super.initState();
    _fetchTodayLog(); // Fetch log when page initializes
  }

  Future<void> _fetchTodayLog() async {
    final log = await CalorieLogService.fetchTodayCalorieLog();

    // Build loggedFoods Map
    final Map<String, Set<String>> tempLoggedFoods = {};

    if (log != null) {
      final meals = log['meals'] as List<dynamic>? ?? [];
      for (final meal in meals) {
        final mealName = meal['name'] as String? ?? '';
        final foods = meal['foods'] as List<dynamic>? ?? [];

        tempLoggedFoods[mealName] =
            foods.map((f) => f['name'].toString()).toSet();
      }
    }

    setState(() {
      loggedFoods = tempLoggedFoods;
    });
  }

  bool isFoodLogged(String mealName, FoodProduct product) {
    if (todayCalorieLog == null) return false;

    final meals = todayCalorieLog!['meals'] as List<dynamic>? ?? [];
    for (final meal in meals) {
      if (meal['name'] == mealName) {
        final foods = meal['foods'] as List<dynamic>? ?? [];
        if (foods.any((f) => f['name'] == product.name)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.data['goal'] ?? 'N/A';
    final dietType = widget.data['dietType'] ?? 'N/A';
    final mealsPerDay =
        int.tryParse(widget.data['mealsPerDay']?.toString() ?? '3') ?? 3;
    final selectedStapleFoods =
        (widget.data['selectedStapleFoods'] as List<dynamic>?)
            ?.cast<String>() ??
        [];

    final double tdee =
        (widget.data['tdee'] is num)
            ? (widget.data['tdee'] as num).toDouble()
            : 0;
    final double calorieTarget = CalorieIntakeCalculator.calculateCalorieTarget(
      tdee,
      goal,
    );
    final Map<String, double> macros = CalorieIntakeCalculator.calculateMacros(
      calorieTarget,
      goal,
    );
    final mealLabels = ['Breakfast', 'Lunch', 'Dinner'];
    if (mealsPerDay == 4) mealLabels.add('Snacks');

    // Define calorie distribution percentages based on mealsPerDay
    Map<String, double> calorieDistribution;
    if (mealsPerDay == 4) {
      calorieDistribution = {
        'Breakfast': 0.20,
        'Lunch': 0.30,
        'Dinner': 0.30,
        'Snacks': 0.20,
      };
    } else if (mealsPerDay == 3) {
      calorieDistribution = {'Breakfast': 0.25, 'Lunch': 0.35, 'Dinner': 0.40};
    } else {
      throw Exception("Unsupported number of meals: $mealsPerDay");
    }

    // Calculate calories for each selected meal
    final Map<String, double> caloriesPerMeal = {};
    for (final meal in mealLabels) {
      final percent = calorieDistribution[meal] ?? 0.0;
      caloriesPerMeal[meal] = calorieTarget * percent;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Diet Plan")),
      body: FutureBuilder<Map<String, List<FoodProduct>>>(
        future:
            widget.cachedMealPlan != null
                ? Future.value(widget.cachedMealPlan)
                : MealPlanGenerator.generateMealPlan(
                  mealLabels,
                  selectedStapleFoods,
                  dietType,
                  caloriesPerMeal,
                ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final mealPlan = snapshot.data ?? {};

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Text(
                  "Fitness Goal: $goal",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                CalorieTrackerPage(calorieGoal: calorieTarget),
                      ),
                    );
                  },
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text("Track Your Calories"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Diet Type: $dietType",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Meals Per Day: $mealsPerDay",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Staple Foods:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children:
                      selectedStapleFoods
                          .map((food) => Chip(label: Text(food)))
                          .toList(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/diet_questions');
                  },
                  child: const Text("Edit Diet Preferences"),
                ),
                const SizedBox(height: 30),
                Card(
                  color: Colors.deepPurple.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calorie & Macronutrient Breakdown',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Calorie Target: ${calorieTarget.toStringAsFixed(0)} kcal/day',
                        ),
                        Text(
                          'Protein: ${macros['protein_g']?.toStringAsFixed(1)} g',
                        ),
                        Text('Fat: ${macros['fat_g']?.toStringAsFixed(1)} g'),
                        Text(
                          'Carbohydrates: ${macros['carbs_g']?.toStringAsFixed(1)} g',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Recommended Diet Plan:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...mealLabels.map((mealName) {
                  final products = mealPlan[mealName] ?? [];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mealName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final updatedMeal = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => EditMealPage(
                                            mealName: mealName,
                                            currentFoods: products,
                                          ),
                                    ),
                                  );

                                  if (updatedMeal != null) {
                                    setState(() {
                                      // Replace entire meal with updatedMeal
                                      mealPlan[mealName] = updatedMeal;
                                    });

                                    // Update Firestore
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    if (user != null) {
                                      final updatedPlan = {
                                        for (final entry in mealPlan.entries)
                                          entry.key:
                                              entry.value
                                                  .map((food) => food.toJson())
                                                  .toList(),
                                      };

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .update({
                                            'generatedDietPlan': updatedPlan,
                                          });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Meal updated successfully!',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _buildMacroSummary(products),
                          const Divider(height: 20),
                          ...products.map((product) {
                            final alreadyEaten =
                                loggedFoods[mealName]?.contains(product.name) ??
                                false;
                            return ListTile(
                              title: Text(product.name),
                              subtitle: Text(
                                '${product.calories.toStringAsFixed(0)} kcal | '
                                '${product.protein.toStringAsFixed(1)}g protein | '
                                '${product.fat.toStringAsFixed(1)}g fat | '
                                '${product.carbs.toStringAsFixed(1)}g carbs',
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  alreadyEaten
                                      ? Icons.check
                                      : Icons.check_circle,
                                  color:
                                      alreadyEaten ? Colors.green : Colors.grey,
                                ),
                                tooltip:
                                    alreadyEaten
                                        ? 'Remove from Log'
                                        : 'Mark as Eaten',
                                onPressed: () async {
                                  setState(() {
                                    if (alreadyEaten) {
                                      loggedFoods[mealName]?.remove(
                                        product.name,
                                      );
                                    } else {
                                      loggedFoods
                                          .putIfAbsent(mealName, () => {})
                                          .add(product.name);
                                    }
                                  });

                                  try {
                                    if (alreadyEaten) {
                                      await CalorieLogService.removeFoodFromToday(
                                        mealName,
                                        product,
                                      );
                                    } else {
                                      await CalorieLogService.logMealForToday(
                                        mealName,
                                        [product],
                                      );
                                    }
                                  } catch (e) {
                                    setState(() {
                                      if (alreadyEaten) {
                                        loggedFoods
                                            .putIfAbsent(mealName, () => {})
                                            .add(product.name);
                                      } else {
                                        loggedFoods[mealName]?.remove(
                                          product.name,
                                        );
                                      }
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to ${alreadyEaten ? 'remove' : 'log'} ${product.name}: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildMacroSummary(List<FoodProduct> products) {
  final totalCalories = products.fold(0.0, (sum, f) => sum + f.calories);
  final totalProtein = products.fold(0.0, (sum, f) => sum + f.protein);
  final totalFat = products.fold(0.0, (sum, f) => sum + f.fat);
  final totalCarbs = products.fold(0.0, (sum, f) => sum + f.carbs);

  return Wrap(
    spacing: 10,
    children: [
      _macroTag("🍽", "${totalCalories.toStringAsFixed(0)} kcal"),
      _macroTag("🧬", "${totalProtein.toStringAsFixed(1)}g protein"),
      _macroTag("🥑", "${totalFat.toStringAsFixed(1)}g fat"),
      _macroTag("🍞", "${totalCarbs.toStringAsFixed(1)}g carbs"),
    ],
  );
}

Widget _macroTag(String emoji, String text) {
  return Chip(
    label: Text("$emoji $text"),
    backgroundColor: Colors.deepPurple.shade50,
  );
}
