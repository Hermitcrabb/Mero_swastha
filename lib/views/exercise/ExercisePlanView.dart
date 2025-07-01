import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExercisePlanView extends StatelessWidget {
  final Map<String, dynamic> data;

  static const Map<String, String> exerciseVideos = {
    'High Knees': 'X4ymugfzwU0',
    'Bodyweight Lunges': 'NLtWEMQ8FsY',
    // ... keep all your other video mappings ...
  };

  const ExercisePlanView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final exercises = _generateExercisePlan();
    return _buildExerciseList(exercises); // Directly return the list without Scaffold
  }

  Widget _buildExerciseList(List<String> exercises) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ExerciseVideoCard(
          title: exercise,
          videoId: exerciseVideos[exercise] ?? 'I9nG-G4B5Bs',
        );
      },
    );
  }

  List<String> _generateExercisePlan() {
    final goal = data['goal'] ?? 'maintenance';
    final experience = data['experience'] ?? 'beginner';
    final location = data['workoutLocation'] ?? 'home';
    final equipment = data['equipment'] ?? [];

    return _selectExercises(goal, experience, location, equipment);
  }

  List<String> _selectExercises(String goal, String exp, String location, List equipment) {
    final isHome = location == 'home';
    final hasDumbbells = equipment.contains('Dumbbells');
    final hasBands = equipment.contains('Resistance Bands');

    switch ('$goal-$exp') {
      case 'muscle_gain-beginner':
        return isHome
            ? [
          if (hasDumbbells) 'Dumbbell Squats',
          if (hasDumbbells) 'Dumbbell Shoulder Press',
          if (!hasDumbbells) 'Push-ups',
          if (!hasDumbbells) 'Bodyweight Squats',
          'Plank'
        ]
            : [
          'Machine Chest Press',
          'Lat Pulldown',
          'Leg Press',
          'Cable Rows'
        ];
    // ... keep all your other exercise selection logic ...
      default:
        return [
          'Push-ups',
          'Bodyweight Lunges',
          'Plank',
          'Jump Rope',
          if (hasBands) 'Band Pull Aparts',
        ];
    }
  }
}

class ExerciseVideoCard extends StatefulWidget {
  final String title;
  final String videoId;

  const ExerciseVideoCard({
    super.key,
    required this.title,
    required this.videoId,
  });

  @override
  State<ExerciseVideoCard> createState() => _ExerciseVideoCardState();
}

class _ExerciseVideoCardState extends State<ExerciseVideoCard> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          YoutubePlayer(
            controller: _controller,
            aspectRatio: 16 / 9,
            showVideoProgressIndicator: true,
          ),
        ],
      ),
    );
  }
}