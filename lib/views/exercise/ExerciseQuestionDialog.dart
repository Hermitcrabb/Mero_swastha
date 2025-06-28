import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExerciseQuestionDialog extends StatefulWidget {
  final String uid;

  const ExerciseQuestionDialog({super.key, required this.uid});

  @override
  State<ExerciseQuestionDialog> createState() => _ExerciseQuestionDialogState();
}

class _ExerciseQuestionDialogState extends State<ExerciseQuestionDialog> {
  final _formKey = GlobalKey<FormState>();

  String goal = 'muscle_gain';
  String experience = 'beginner';
  String workoutLocation = 'home';
  List<String> selectedEquipment = [];
  int workoutDaysPerWeek = 3;

  final equipmentOptions = ['Dumbbells', 'Resistance Bands', 'Yoga Mat', 'Pull-up Bar'];

  bool isSaving = false;

  void submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
        'exerciseProfile': {
          'goal': goal,
          'experience': experience,
          'workoutLocation': workoutLocation,
          'equipment': selectedEquipment,
          'workoutDaysPerWeek': workoutDaysPerWeek,
        }
      });

      Navigator.of(context).pop(); // Close dialog
    } catch (e) {
      Get.snackbar("Error", "Failed to save exercise info.");
    }

    setState(() => isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tell us about your fitness goal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: goal,
                  items: const [
                    DropdownMenuItem(value: 'muscle_gain', child: Text('Muscle Gain')),
                    DropdownMenuItem(value: 'weight_loss', child: Text('Weight Loss')),
                    DropdownMenuItem(value: 'maintenance', child: Text('Maintenance')),
                  ],
                  onChanged: (val) => setState(() => goal = val!),
                  decoration: const InputDecoration(labelText: "Your Goal"),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: experience,
                  items: const [
                    DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                    DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                    DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                  ],
                  onChanged: (val) => setState(() => experience = val!),
                  decoration: const InputDecoration(labelText: "Experience Level"),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: workoutLocation,
                  items: const [
                    DropdownMenuItem(value: 'home', child: Text('Home')),
                    DropdownMenuItem(value: 'gym', child: Text('Gym')),
                    DropdownMenuItem(value: 'outdoor', child: Text('Outdoor')),
                  ],
                  onChanged: (val) => setState(() => workoutLocation = val!),
                  decoration: const InputDecoration(labelText: "Workout Location"),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: equipmentOptions.map((eq) {
                    final isSelected = selectedEquipment.contains(eq);
                    return FilterChip(
                      label: Text(eq),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedEquipment.add(eq);
                          } else {
                            selectedEquipment.remove(eq);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  initialValue: workoutDaysPerWeek.toString(),
                  decoration: const InputDecoration(labelText: "Workout Days per Week"),
                  keyboardType: TextInputType.number,
                  onSaved: (val) {
                    workoutDaysPerWeek = int.tryParse(val ?? '') ?? 3;
                  },
                ),

                const SizedBox(height: 24),

                isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                  child: const Text("Submit", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
