import 'package:flutter/material.dart';
import '../calorie_log_service.dart'; // Adjust import path accordingly

class CalorieTrackerPage extends StatefulWidget {
  final double calorieGoal;

  const CalorieTrackerPage({super.key, required this.calorieGoal});

  @override
  State<CalorieTrackerPage> createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends State<CalorieTrackerPage> {
  Map<String, dynamic>? calorieLog;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCalorieLog();
  }

  Future<void> fetchCalorieLog() async {
    setState(() => isLoading = true);
    calorieLog = await CalorieLogService.fetchTodayCalorieLog();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = (calorieLog?['totalCalories'] ?? 0).toDouble();
    final totalProtein = (calorieLog?['totalProtein'] ?? 0).toDouble();
    final totalFat = (calorieLog?['totalFat'] ?? 0).toDouble();
    final totalCarbs = (calorieLog?['totalCarbs'] ?? 0).toDouble();

    final calorieProgress = (widget.calorieGoal == 0)
        ? 0
        : (totalCalories / widget.calorieGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calories Consumed: ${totalCalories.toStringAsFixed(0)} / ${widget.calorieGoal.toStringAsFixed(0)} kcal',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: calorieProgress,
              minHeight: 20,
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                _macroChip('Protein', '${totalProtein.toStringAsFixed(1)}g', Colors.blue),
                _macroChip('Fat', '${totalFat.toStringAsFixed(1)}g', Colors.orange),
                _macroChip('Carbs', '${totalCarbs.toStringAsFixed(1)}g', Colors.purple),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Logged Meals:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: (calorieLog?['meals'] != null)
                  ? ListView.builder(
                itemCount: calorieLog!['meals'].length,
                itemBuilder: (context, index) {
                  final meal = calorieLog!['meals'][index];
                  final foods = List<Map<String, dynamic>>.from(meal['foods']);

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal['name'] ?? 'Meal',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Divider(),
                          ...foods.map((food) => ListTile(
                            title: Text(food['name']),
                            subtitle: Text(
                              '${food['calories'].toStringAsFixed(0)} kcal | '
                                  '${food['protein'].toStringAsFixed(1)}g protein | '
                                  '${food['fat'].toStringAsFixed(1)}g fat | '
                                  '${food['carbs'].toStringAsFixed(1)}g carbs',
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              )
                  : const Text('No meals logged yet.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroChip(String label, String value, Color color) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }
}
