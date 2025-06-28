import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExercisePlanView extends StatelessWidget {
  final Map<String, dynamic> data;

  static const Map<String, String> exerciseVideos = {
    'High Knees': 'X4ymugfzwU0',
    'Bodyweight Lunges': 'NLtWEMQ8FsY',
    'Burpees': 'NN6HMYdnB-0',
    'Jump Rope': 'iriqBoUZj6c',
    'Band Pull Aparts': 'wbY3CaH6QnY',
    'Push-ups': 'MtJfzXl5jVM',
    'Plank': 'D09fgdZMD-0',
    'Machine Chest Press': 'X4cKl9b1Vpg',
    'Lat Pulldown': 'tmUp5Uw6zSg',
    'Dumbbell Squats': 'gB2zaYonCDk',
    'Leg Press': 'yFRv2HZWZGg',
    'Cable Rows': 'zZrfn5KRyu8',
    'Split Squats': 'H-MQ1_M-vnE',
    'Incline Push-ups': '8pis5jU4vsI',
    'Renegade Rows': 'iSq2xswhj5g',
    'Jumping Jacks': 'fjXazOW6Bjw',
    'Mountain Climbers': 'UzIBymj6a7c',
    'Resistance Band Squats': 'UxLbnT-avko',
    'Dumbbell Thrusters': 'Wn4L4Fw3nCI',
    'Dumbbell Shoulder Press': 'b9kxbZhCcq0',
    'Dumbbell Deadlift': 'kDbhBp6eNf4',
    'Bodyweight Squats': 'YaXPRqUwItQ',
    'Plank to Push-up': 'z6PJMT2y8GQ',
    'Go for a brisk walk or bodyweight circuit.': 'I9nG-G4B5Bs',
  };

  const ExercisePlanView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safely extract values with fallback defaults
    final String goal = data['goal'] ?? 'maintenance';
    final String experience = data['experience'] ?? 'beginner';
    final String location = data['workoutLocation'] ?? 'home';
    final List equipment = data['equipment'] ?? [];

    final List<String> exercises = generatePlan(goal, experience, location, equipment);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Exercise Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            final videoId = exerciseVideos[exercise] ?? 'I9nG-G4B5Bs';
            return ExerciseVideoCard(title: exercise, videoId: videoId);
          },
        ),
      ),
    );
  }

  List<String> generatePlan(String goal, String exp, String location, List equipment) {
    final List<String> exercises = [];

    final bool isHome = location == 'home';
    final bool hasDumbbells = equipment.contains('Dumbbells');
    final bool hasBands = equipment.contains('Resistance Bands');

    if (goal == 'muscle_gain') {
      if (exp == 'beginner') {
        exercises.addAll([
          if (isHome) ...[
            if (hasDumbbells) 'Dumbbell Squats',
            if (hasDumbbells) 'Dumbbell Shoulder Press',
            if (!hasDumbbells) 'Push-ups',
            if (!hasDumbbells) 'Bodyweight Squats',
            'Plank'
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
          'Plank to Push-up',
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
        'Jump Rope',
        if (hasBands) 'Band Pull Aparts',
      ]);
    }

    if (exercises.isEmpty) {
      exercises.add('Go for a brisk walk or bodyweight circuit.');
    }

    return exercises;
  }
}

class ExerciseVideoCard extends StatefulWidget {
  final String title;
  final String videoId;

  const ExerciseVideoCard({Key? key, required this.title, required this.videoId}) : super(key: key);

  @override
  State<ExerciseVideoCard> createState() => _ExerciseVideoCardState();
}

class _ExerciseVideoCardState extends State<ExerciseVideoCard> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            builder: (context, player) => AspectRatio(
              aspectRatio: 16 / 9,
              child: player,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
