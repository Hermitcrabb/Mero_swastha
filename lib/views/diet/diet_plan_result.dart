import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'calorie_intake_calculate.dart';
import 'food_product_service.dart'; // if you kept it
import 'food_product.dart'; // if your model is in separate file

class DietPlanResult extends StatelessWidget {
  final Map<String, dynamic> data;

  const DietPlanResult({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final goal = data['goal'] ?? 'N/A';
    final dietType = data['dietType'] ?? 'N/A';
    final mealsPerDay = data['mealsPerDay']?.toString() ?? '3';
    final selectedStapleFoods = (data['selectedStapleFoods'] as List<dynamic>?)?.cast<String>() ?? [];

    final double tdee = (data['tdee'] is num) ? (data['tdee'] as num).toDouble() : 0;
    final double calorieTarget = CalorieIntakeCalculator.calculateCalorieTarget(tdee, goal);
    final Map<String, double> macros = CalorieIntakeCalculator.calculateMacros(calorieTarget, goal);
    final double caloriesPerMeal = calorieTarget / int.parse(mealsPerDay);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Diet Plan")),
      body: FutureBuilder(
        future: FoodProductService.fetchProductsByStapleAndDiet(selectedStapleFoods, dietType),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No suitable products found."));
          }

          final allProducts = snapshot.data as List<FoodProduct>;
          final selectedMeals = FoodProductService.selectProductsForMeal(allProducts, caloriesPerMeal);

          // 🔍 Print to debug console
          print("All Fetched Products:");
          for (var p in allProducts) {
            print("${p.name} - ${p.calories} kcal");
          }

          print("\nSelected Meal:");
          for (var m in selectedMeals) {
            print("${m.name} - ${m.calories} kcal");
          }

          // Build your UI below ⬇️
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                // Existing UI
                Text("Fitness Goal: $goal", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Diet Type: $dietType", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text("Meals Per Day: $mealsPerDay", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text("Staple Foods:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: selectedStapleFoods.map((food) => Chip(label: Text(food))).toList(),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calorie & Macronutrient Breakdown',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 10),
                        Text('Calorie Target: ${calorieTarget.toStringAsFixed(0)} kcal/day'),
                        Text('Protein: ${macros['protein_g']?.toStringAsFixed(1)} g'),
                        Text('Fat: ${macros['fat_g']?.toStringAsFixed(1)} g'),
                        Text('Carbohydrates: ${macros['carbs_g']?.toStringAsFixed(1)} g'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Text('Recommended Products for Meal:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...selectedMeals.map((product) => ListTile(
                  title: Text(product.name),
                  subtitle: Text('${product.calories.toStringAsFixed(0)} kcal | '
                      '${product.protein.toStringAsFixed(1)}g protein | '
                      '${product.fat.toStringAsFixed(1)}g fat | '
                      '${product.carbs.toStringAsFixed(1)}g carbs'),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
