import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../bmi/bmi_page.dart';

class DietQuestions extends StatefulWidget {
  const DietQuestions({super.key});

  @override
  State<DietQuestions> createState() => _DietQuestionsState();
}

class _DietQuestionsState extends State<DietQuestions> {
  final _formKey = GlobalKey<FormState>();

  double? bmi;
  double? tdee;
  bool isLoading = true;
  String? goal;
  String dietType = "Vegetarian";
  List<String> selectedStapleFoods = [];
  int mealsPerDay = 3;

  final List<String> nepaliStapleFoods = [
    "Rice",
    "Dal",
    "Vegetables",
    "Milk",
    "Yogurt",
    "Roti",
    "Curry",
    "Pickle",
    "Ghee",
    "Egg",
    "Chicken",
    "Paneer",
    "Soybean",
    "Beans",
    "Green Leafy Veggies",
    "Mushroom",
    "Fish",
    "Buff Meat"
  ];

  @override
  void initState() {
    super.initState();
    _loadDietPreferences();
  }

  Future<void> _loadDietPreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data != null && data['dietPreferences'] != null) {
      final prefs = data['dietPreferences'] as Map<String, dynamic>;

      setState(() {
        goal = prefs['goal'] ?? goal;
        dietType = prefs['dietType'] ?? dietType;
        mealsPerDay = prefs['mealsPerDay'] ?? mealsPerDay;
        selectedStapleFoods = List<String>.from(prefs['selectedStapleFoods'] ?? []);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // save preferences to Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'dietPreferences': {
          'goal': goal,
          'dietType': dietType,
          'selectedStapleFoods': selectedStapleFoods,
          'mealsPerDay': mealsPerDay,
          'bmi': bmi ?? 0,  // store 0 if null to avoid null issues
          'tdee': tdee ?? 0,
          'timestamp': FieldValue.serverTimestamp(),
        }
      });

      // pop back (no need to send result now)
      Navigator.pop(context);
    }
  }


  Widget _buildStapleFoodChips() {
    return Wrap(
      spacing: 10,
      children: nepaliStapleFoods.map((food) {
        final isSelected = selectedStapleFoods.contains(food);
        return FilterChip(
          label: Text(food),
          selected: isSelected,
          selectedColor: Colors.deepPurple.shade100,
          checkmarkColor: Colors.deepPurple,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedStapleFoods.add(food);
              } else {
                selectedStapleFoods.remove(food);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Future<void> _navigateToBmiAndSetGoal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BmiPage(returnGoal: true)),
    );

    if (result != null && mounted) {
      setState(() {
        goal = result['goal'] as String?;
        bmi = result['bmi'] as double?;
        tdee = result['tdee'] as double?;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Diet Plan Questionnaire")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // DropdownButtonFormField<String>(
              //   value: goal,
              //   items: ["Lose Weight", "Gain Muscle", "Maintain Weight"]
              //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              //       .toList(),
              //   onChanged: (value) => setState(() => goal = value!),
              // ),
              Row(
                children: [
                  Expanded(
                    child: goal != null
                        ? TextFormField(
                      enabled: false,
                      initialValue: goal,
                      decoration: InputDecoration(
                        labelText: "Fitness Goal (calculated via BMI)",
                        border: OutlineInputBorder(),
                      ),
                    )
                        : Text(
                      "Please calculate your fitness goal using BMI",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calculate, color: Colors.deepPurple),
                    tooltip: "Calculate with BMI",
                    onPressed: _navigateToBmiAndSetGoal,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text("What is your diet preference?", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: dietType,
                items: ["Vegetarian", "Non-Vegetarian", "Vegan"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => dietType = value!),
              ),
              const SizedBox(height: 16),

              const Text("Select your staple foods:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildStapleFoodChips(),
              const SizedBox(height: 16),

              const Text("How many meals per day?", style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                value: mealsPerDay,
                items: [3, 4, 5]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (value) => setState(() => mealsPerDay = value!),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: goal == null ? null : _submit, // disabled if goal not set
                child: const Text("Generate Diet Plan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
