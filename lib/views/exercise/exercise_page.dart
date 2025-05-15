import 'package:flutter/material.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Exercise Routines",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Stay active with these personalized routines based on your level.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            _buildRoutineCard(
              title: "Beginner Level",
              description:
              "Perfect for those starting their fitness journey. These exercises help build foundation strength and endurance.",
              exercises: [
                "• 15-minute walk",
                "• Bodyweight squats (3x10)",
                "• Push-ups (3x5)",
                "• Plank (3x20 seconds)",
              ],
              icon: Icons.directions_walk,
            ),

            const SizedBox(height: 20),

            _buildRoutineCard(
              title: "Intermediate Level",
              description:
              "For regular exercisers. These routines focus on increasing strength and stamina.",
              exercises: [
                "• 5-min warm-up jog",
                "• Lunges (3x10 each leg)",
                "• Push-ups (3x10)",
                "• Mountain climbers (3x20 seconds)",
                "• Plank (3x30 seconds)",
              ],
              icon: Icons.fitness_center,
            ),

            const SizedBox(height: 20),

            _buildRoutineCard(
              title: "Advanced Level",
              description:
              "High-intensity workouts for experienced individuals to boost muscle and endurance.",
              exercises: [
                "• 10-min run",
                "• Jump squats (3x12)",
                "• Burpees (3x10)",
                "• Push-ups (4x15)",
                "• Plank (4x45 seconds)",
              ],
              icon: Icons.flash_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard({
    required String title,
    required String description,
    required List<String> exercises,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            ...exercises.map((e) => Text(e, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}
