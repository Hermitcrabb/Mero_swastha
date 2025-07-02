import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Exercise {
  final String name;
  final String videoPath;
  final double caloriesPerMinute;
  final String instructions;
  final List<String> requiredEquipment; // List of required equipment

  const Exercise({
    required this.name,
    required this.videoPath,
    required this.caloriesPerMinute,
    required this.instructions,
    this.requiredEquipment = const [], // Default to an empty list
  });
}

class ExercisePlanView extends StatelessWidget {
  final Map<String, dynamic> data;

  // Local exercise database
  static const Map<String, List<Exercise>> exerciseDatabase = {
    'Build-muscle-beginner-home': [
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Incline push-ups',
        videoPath: 'assets/videos/incline_pushups.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical Air-punches',
        videoPath: 'assets/videos/vertical_air_punches.mp4',
        caloriesPerMinute: 1,
        instructions: 'Punch for 5 minutes to have effect',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Chair Dips',
        videoPath: 'assets/videos/chair_dips.mp4',
        caloriesPerMinute: 2.5,
        instructions: '3 set of 10 reps',
        requiredEquipment: ['Chair'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Dumbbell Squats',
        videoPath: 'assets/videos/kettlebell_squats.mp4',
        caloriesPerMinute: 4,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      // Add more exercises
    ],
    'Build-muscle-intermediate-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
      ),
      Exercise(
        name: 'Jump ropes',
        videoPath: 'assets/videos/jump_ropes.mp4',
        caloriesPerMinute: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: ['Ropes'],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'assets/videos/knee_pull.mp4',
        caloriesPerMinute: 3.5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Laying abdominal crunches',
        videoPath: 'assets/videos/laying_abdominal_crunches.mp4',
        caloriesPerMinute: 3.5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Leg raises',
        videoPath: 'assets/videos/leg_raises.mp4',
        caloriesPerMinute: 5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Push ups',
        videoPath: 'assets/videos/pushups.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Build-muscle-advanced-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Cross over squats',
        videoPath: 'assets/videos/crossover_squat.mp4',
        caloriesPerMinute: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell low windmill',
        videoPath: 'assets/videos/dumbbell_low_windmill.mp4',
        caloriesPerMinute: 3.5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Skull crusher',
        videoPath: 'assets/videos/skull_crusher.mp4',
        caloriesPerMinute: 3.5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: ['Barbell'],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'assets/videos/star_jump.mp4',
        caloriesPerMinute: 5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm wrist curls',
        videoPath: 'assets/videos/one_arm_wrist_extension.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'Build-muscle-beginner-gym': [
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Machine Chest Press',
        videoPath: 'assets/videos/barbell_chestpress.mp4',
        caloriesPerMinute: 6,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Biceps curls',
        videoPath: 'assets/videos/Biceps_curl.mp4',
        caloriesPerMinute: 8,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Biceps curls ropes',
        videoPath: 'assets/videos/Biceps_curl_ropes.mp4',
        caloriesPerMinute: 8,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell overhead walk',
        videoPath: 'assets/videos/dumbbell_overhead_walk.mp4',
        caloriesPerMinute: 6,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hyperextension',
        videoPath: 'assets/videos/hyperextension.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      // Add more exercises
    ],
    'Build-muscle-intermediate-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell clean press',
        videoPath: 'assets/videos/Barbell_Clean_press.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'assets/videos/Barbell_rows.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell squats',
        videoPath: 'assets/videos/Barbell_squats.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Lateral raises ',
        videoPath: 'assets/videos/Layeral_Raises.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'assets/videos/shoulder_press.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'assets/videos/star_jump.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Sumo dead lift',
        videoPath: 'assets/videos/sumo_deadlift.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Build-muscle-advanced-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell clean press',
        videoPath: 'assets/videos/Barbell_Clean_press.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'assets/videos/Barbell_rows.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'assets/videos/Barbell_rows.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell squats',
        videoPath: 'assets/videos/Barbell_squats.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Lateral raises ',
        videoPath: 'assets/videos/Layeral_Raises.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'assets/videos/shoulder_press.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Courtesy lunges',
        videoPath: 'assets/videos/curtesy_lunges.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Sumo dead lift',
        videoPath: 'assets/videos/sumo_deadlift.mp4',
        caloriesPerMinute: 5,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Build-muscle-Outdoor/Public-Spaces-beginner':[
      Exercise(
        name: 'Incline push-ups',
        videoPath: 'assets/videos/incline_pushups.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical Air-punches',
        videoPath: 'assets/videos/vertical_air_punches.mp4',
        caloriesPerMinute: 1,
        instructions: 'Punch for 5 minutes to have effect',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      )
    ],
    'Build-muscle-Outdoor/Public-Spaces-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'assets/videos/45_degree_knee_to_elbow.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
          instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Arm to side',
        videoPath: 'assets/videos/arm_to_side.mp4',
        caloriesPerMinute: 2.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'assets/videos/iron_crush.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'Build-muscle-Outdoor/Public-Spaces-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'assets/videos/45_degree_knee_to_elbow.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'assets/videos/iron_crush.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'assets/videos/dumbbell_press.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Hamstring curl punch',
        videoPath: 'assets/videos/hamstringcurl_puch.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Lose-weight-home-beginner':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'assets/videos/45_degree_knee_to_elbow.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'assets/videos/iron_crush.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'assets/videos/dumbbell_press.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
      ),
    ],
    'Lose-weight-home-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'assets/videos/45_degree_knee_to_elbow.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Courtesy lunges',
        videoPath: 'assets/videos/curtesy_lunges.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'assets/videos/dumbbell_press.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dips',
        videoPath: 'assets/videos/Dips.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
      ),
    ],
    'Lose-weight-home-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'assets/videos/Tricep_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'assets/videos/star_jump.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'assets/videos/iron_crush.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'assets/videos/dumbbell_press.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dips',
        videoPath: 'assets/videos/Dips.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Chairs'],
      ),
      Exercise(
        name: 'Dumbbell press extension',
        videoPath: 'assets/videos/Dumbbell_press_extension.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Glute bridge',
        videoPath: 'assets/videos/glute_bridge.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Lose-weight-gym-beginner':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Horizontal punch',
        videoPath: 'assets/videos/horizontal_punch.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hamstring curl punch',
        videoPath: 'assets/videos/hamstringcurl_puch.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hyper extension',
        videoPath: 'assets/videos/hyperextension.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['chair'],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dips',
        videoPath: 'assets/videos/Dips.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Chairs'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
      ),
    ],
    'Lose-weight-gym-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder squat',
        videoPath: 'assets/videos/squat_shoulder.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hamstring lunges',
        videoPath: 'assets/videos/split_sqaut.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'assets/videos/shoulder_press.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [''],
      ),
      Exercise(
        name: 'Seated back Shoulder',
        videoPath: 'assets/videos/seatedback_shoulder.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm cable',
        videoPath: 'assets/videos/oneorm_cable.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell forearm',
        videoPath: 'assets/videos/dumbbell_forearm.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),

    ],
    'Lose-weight-gym-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell hip extension',
        videoPath: 'assets/videos/dumbbell_hip_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Glute bridge',
        videoPath: 'assets/videos/glute_bridge.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'assets/videos/shoulder_press.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [''],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'assets/videos/star_jump.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm cable',
        videoPath: 'assets/videos/oneorm_cable.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Archer pushups',
        videoPath: 'assets/videos/archer_pushups.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell Chestpress',
        videoPath: 'assets/videos/barbell_chestpress.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'assets/videos/Barbell_rows.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell burpees',
        videoPath: 'assets/videos/dumbbell_burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'Lose-weight-Outdoor/Public-Spaces-beginner':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'assets/videos/45_degree_knee_to_elbow.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical air punches',
        videoPath: 'assets/videos/vertical_air_punches.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell low windmill',
        videoPath: 'assets/videos/dumbbell_low_windmill.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'assets/videos/Burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
    ],
    'Lose-weight-Outdoor/Public-Spaces-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'assets/videos/Triceps_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical air punches',
        videoPath: 'assets/videos/vertical_air_punches.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Dumbbell burpees',
        videoPath: 'assets/videos/dumbbell_burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'Lose-weight-Outdoor/Public-Spaces-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'assets/videos/Triceps_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell overhead walk',
        videoPath: 'assets/videos/dumbbell_overhead_walk.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'assets/videos/jump_ropes.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Laying abdominal crunches',
        videoPath: 'assets/videos/lay_abdominal_crunches.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
    ],
    'Stay-fit-gym-beginner':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell hip extension',
        videoPath: 'assets/videos/dumbbell_hip_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Seated back shoulder',
        videoPath: 'assets/videos/seatedback_shoulder.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'assets/videos/jump_ropes.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'assets/videos/knee_pull.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Push ups',
        videoPath: 'assets/videos/pushups.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Stay-fit-gym-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'assets/videos/Triceps_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical air punches',
        videoPath: 'assets/videos/vertical_air_punches.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell burpees',
        videoPath: 'assets/videos/dumbbell_burpees.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
    ],
    'Stay-fit-gym-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Lateral raises',
        videoPath: 'assets/videos/Layeral_Raises.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm cable',
        videoPath: 'assets/videos/oneorm_cable.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'assets/videos/shoulder_press.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Skull crushers',
        videoPath: 'assets/videos/skull_crushers.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Split squat',
        videoPath: 'assets/videos/split_sqaut.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Cable overhead extension',
        videoPath: 'assets/videos/cable_overhead_extension.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),

    ],
    'Stay-fit-home-beginner':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'assets/videos/chin_up.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'assets/videos/jump_ropes.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'assets/videos/Triceps_extension.mp4',
        caloriesPerMinute: 3.5,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'assets/videos/45_degree_side_bend.mp4',
        caloriesPerMinute: 3,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Stay-fit-home-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Squat shoulder',
        videoPath: 'assets/videos/squat_shoulder.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'assets/videos/iron_crush.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Biceps curl',
        videoPath: 'assets/videos/Biceps_curl.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Biceps_curl'],
      ),
    ],
    'Stay-fit-home-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name : 'Archer pushups',
        videoPath: 'assets/videos/archer_pushups.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'assets/videos/Barbell_rows.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Barbell'],
      ),
      Exercise(
        name: 'Barbell squats',
        videoPath: 'assets/videos/barbell_squats.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Barbell'],
      ),
      Exercise(
        name: 'Barbell clean press',
        videoPath: 'assets/videos/Barbell_Clean_press.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Barbell'],
      ),
    ],
    'Stay-fit-Outdoor/Public-Spaces-beginner':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'assets/videos/jump_ropes.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: ['Ropes'],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'assets/videos/knee_pull.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Push ups',
        videoPath: 'assets/videos/pushups.mp4',
        caloriesPerMinute: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'Stay-fit-Outdoor/Public-Spaces-intermediate':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
    ],
    'Stay-fit-Outdoor/Public-Spaces-advanced':[
      Exercise(
        name: 'Stretching',
        videoPath: 'assets/videos/streatching.mp4',
        caloriesPerMinute: 1,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'assets/videos/star_jump.mp4',
        caloriesPerMinute: 1.5,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Courtesy lunges',
        videoPath: 'assets/videos/curtesy_lunges.mp4',
        caloriesPerMinute: 4,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'assets/videos/knee_pull.mp4',
        caloriesPerMinute: 3.5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Laying abdominal crunches',
        videoPath: 'assets/videos/laying_abdominal_crunches.mp4',
        caloriesPerMinute: 3.5,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
    ],
    // Add all your combinations
  };

  const ExercisePlanView({super.key, required this.data});

  List<Exercise> _generatePlan() {
    final goal = data['goal'] ?? 'maintenance';
    final experience = data['experience'] ?? 'beginner';
    final location = data['workoutLocation'] ?? 'home';
    final List<String> userEquipment = List<String>.from(data['equipment'] ?? []);

    final key = '$goal-$experience-$location';
    final List<Exercise> allExercises = exerciseDatabase[key] ?? [];

    // If location gym, all exercise available
    if (location == 'gym') {
      return allExercises;
    }


    // Filter exercises based on required equipment
    return allExercises.where((exercise) {
      if (exercise.requiredEquipment.isEmpty) return true; // No equipment needed
      return exercise.requiredEquipment.every((e) => userEquipment.contains(e));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _generatePlan();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Exercise Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showPlanInfo(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ExerciseCard(exercise: exercises[index]);
        },
      ),
    );
  }

  void _showPlanInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Plan Information'),
        content: Text(
          'Based on your goals: ${data['goal']}\n'
              'Experience level: ${data['experience']}\n'
              'Workout location: ${data['workoutLocation']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.exercise.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${widget.exercise.caloriesPerMinute} cal/min'),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
          ),
          if (_isExpanded)
            ExerciseVideoPlayer(videoPath: widget.exercise.videoPath),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.exercise.instructions,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }
}

class ExerciseVideoPlayer extends StatefulWidget {
  final String videoPath;

  const ExerciseVideoPlayer({super.key, required this.videoPath});

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.asset(widget.videoPath);

    try {
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey[300]!,
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Video initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
