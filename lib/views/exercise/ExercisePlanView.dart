import 'package:flutter/material.dart';

class ExercisePlanView extends StatelessWidget {
  final Map<String, dynamic> data;

  const ExercisePlanView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String goal = data['goal'];
    final String experience = data['experience'];
    final String location = data['workoutLocation'];
    final List equipment = data['equipment'] ?? [];
    final int days = data['workoutDaysPerWeek'] ?? 3;

    final List<String> plan = generatePlan(goal, experience, location, equipment);

    return Padding(
      padding: const EdgeInsets.all(16),
    );
  }

  List<String> generatePlan(String goal, String exp, String location, List equipment) {
    final List<String> exercises = [];

    // Starter logic — expand as needed
    final isHome = location == 'home';
    final hasDumbbells = equipment.contains('Dumbbells');
    final hasBands = equipment.contains('Resistance Bands');

    if (goal == 'muscle_gain') {
      if (exp == 'beginner') {
        exercises.addAll([
          if (isHome) ...[
            if (hasDumbbells) 'Dumbbell Squats',
            if (hasDumbbells) 'Dumbbell Shoulder Press',
            if (!hasDumbbells) 'Push-ups',
            if (!hasDumbbells) 'Bodyweight Squats',
            'Plank (30 sec)'
          ] else ...[
            'Machine Chest Press',
            'Lat Pulldown',
            'Leg Press',
            'Cable Rows'
          ]
        ]);
      } else if (exp == 'intermediate') {
        exercises.addAll([
          'Split Squats',
          'Incline Push-ups',
          'Plank to Push-up',//couldnt find
          'Renegade Rows',
          if (hasDumbbells) 'Dumbbell Deadlift',
        ]);
      }
    } else if (goal == 'weight_loss') {
      exercises.addAll([
        'Jumping Jacks',
        'Mountain Climbers',
        if (hasBands) 'Resistance Band Squats',
        if (hasDumbbells) 'Dumbbell Thrusters',
        'High Knees',
        'Burpees',
      ]);
    } else if (goal == 'maintenance') {
      exercises.addAll([
        'Push-ups',
        'Bodyweight Lunges',
        'Plank',
        'Jump Rope (imaginary if no rope)',
        if (hasBands) 'Band Pull Aparts',
      ]);
    }

    // Fallback
    if (exercises.isEmpty) exercises.add('Go for a brisk walk or bodyweight circuit.');

    return exercises;
  }
}
