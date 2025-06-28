import 'package:flutter/material.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  double bmi = 0;
  double tdee = 0;
  String resultMessage = '';
  String suggestion = '';

  // Activity level options
  final List<String> activityLevels = ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active'];
  String selectedActivityLevel = 'Sedentary';

  void calculate() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100; // Convert cm to meters
    int age = int.parse(ageController.text);

    bmi = weight / (height * height);
    tdee = calculateTDEE(weight, height, age);

    // Suggestions based on BMI
    if (bmi < 18.5) {
      suggestion = 'You are underweight. We recommend a bulking plan (+500 kcal/day).';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      suggestion = 'You have a healthy weight. Focus on maintaining your current routine.';
    } else {
      suggestion = 'You are overweight. A cutting plan (-500 kcal/day) is recommended.';
    }

    setState(() {
      resultMessage = "show"; // Trigger UI update
    });
  }

  double calculateTDEE(double weight, double height, int age) {
    double bmr = 10 * weight + 6.25 * height * 100 - 5 * age + 5; // Mifflin-St Jeor Equation for men
    switch (selectedActivityLevel) {
      case 'Sedentary':
        return bmr * 1.2;
      case 'Lightly Active':
        return bmr * 1.375;
      case 'Moderately Active':
        return bmr * 1.55;
      case 'Very Active':
        return bmr * 1.725;
      default:
        return bmr * 1.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI & Daily Calorie Needs"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calculate Your BMI & Daily Calorie Needs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Age input field
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age (in years)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Weight input field
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (in kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),

            // Height input field
            TextField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Height (in cm)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // Activity level dropdown
            DropdownButton<String>(
              value: selectedActivityLevel,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivityLevel = newValue!;
                });
              },
              items: activityLevels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Updated Calculate button
            ElevatedButton(
              onPressed: calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Set the main color of the button
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40), // More padding for a larger button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Add shadow for better depth
                shadowColor: Colors.deepPurple.withOpacity(0.5), // Soft shadow color
              ),
              child: const Text(
                'Calculate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Display BMI and TDEE results
            if (resultMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple.shade200, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Results',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• Body Mass Index (BMI): ${bmi.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '• Daily Calorie Needs: ${tdee.toStringAsFixed(0)} kcal/day',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      suggestion,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: bmi < 18.5
                            ? Colors.orange
                            : (bmi < 25 ? Colors.green
                            : Colors.redAccent),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '👉 Tip: Use these numbers to follow your goal. Our app can help you pick the right meals and workouts!',
                      style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

