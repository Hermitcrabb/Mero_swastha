import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'ExerciseTrackerService.dart';
import 'package:table_calendar/table_calendar.dart';


class Exercise {
  final String name;
  final String videoPath;
  final double? caloriesPerMinute;
  final double? caloriesPerSet;
  final String instructions;
  final List<String> requiredEquipment;
  final int? durationInMinutes;
  final int? totalSets;
  // List of required equipment

  const Exercise({
    required this.name,
    required this.videoPath,
    this.caloriesPerMinute,
    this.caloriesPerSet,
    this.durationInMinutes,
    this.totalSets,
    required this.instructions,
    this.requiredEquipment = const [], // Default to an empty list
  });
}

class ExercisePlanView extends StatelessWidget {
  final Map<String, dynamic> data;

  // Local exercise database
  static const Map<String, List<Exercise>> exerciseDatabase = {
    'muscle_gain-beginner-home': [
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Incline push-ups',
        videoPath: 'videos/incline_pushups.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical Air-punches',
        videoPath: 'videos/vertical_air_punches.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Punch for 5 minutes to have effect',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Chair Dips',
        videoPath: 'videos/chair_dips.mp4',
        caloriesPerSet: 2.5,
        totalSets: 10,
        instructions: '3 set of 10 reps',
        requiredEquipment: ['Chair'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Dumbbell Squats',
        videoPath: 'videos/kettlebell_squats.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      // Add more exercises
    ],
    'muscle_gain-intermediate-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
      ),
      Exercise(
        name: 'Jump ropes',
        videoPath: 'videos/jump_ropes.mp4',
        caloriesPerMinute: 3.2,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: ['Ropes'],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'videos/knee_pull.mp4',
        caloriesPerMinute: 3.5,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Laying abdominal crunches',
        videoPath: 'videos/laying_abdominal_crunches.mp4',
        caloriesPerMinute: 3.5,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Leg raises',
        videoPath: 'videos/leg_raises.mp4',
        caloriesPerMinute: 5,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Push ups',
        videoPath: 'videos/pushups.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
    ],
    'muscle_gain-advanced-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Cross over squats',
        videoPath: 'videos/crossover_squat.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell low windmill',
        videoPath: 'videos/dumbbell_low_windmill.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Skull crusher',
        videoPath: 'videos/skull_crusher.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: ['Barbell'],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'videos/star_jump.mp4',
        caloriesPerMinute: 5,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm wrist curls',
        videoPath: 'videos/one_arm_wrist_extension.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'muscle_gain-beginner-gym': [
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Machine Chest Press',
        videoPath: 'videos/barbell_chestpress.mp4',
        caloriesPerSet: 6,
        totalSets: 12,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Biceps curls',
        videoPath: 'videos/Biceps_curl.mp4',
        caloriesPerSet: 8,
        totalSets: 12,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Biceps curls ropes',
        videoPath: 'videos/Biceps_curl_ropes.mp4',
        caloriesPerSet: 8,
        totalSets: 12,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell overhead walk',
        videoPath: 'videos/dumbbell_overhead_walk.mp4',
        caloriesPerSet: 6,
        totalSets: 12,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hyperextension',
        videoPath: 'videos/hyperextension.mp4',
        caloriesPerSet: 4,
        totalSets: 12,
        instructions: '3 sets of 12 reps',
        requiredEquipment: [],
      ),
      // Add more exercises
    ],
    'muscle_gain-intermediate-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell clean press',
        videoPath: 'videos/Barbell_Clean_press.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'videos/Barbell_rows.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell squats',
        videoPath: 'videos/Barbell_squats.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Lateral raises ',
        videoPath: 'videos/Layeral_Raises.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'videos/shoulder_press.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'videos/star_jump.mp4',
        caloriesPerMinute: 5,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Sumo dead lift',
        videoPath: 'videos/sumo_deadlift.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
    ],
    'muscle_gain-advanced-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell clean press',
        videoPath: 'videos/Barbell_Clean_press.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'videos/Barbell_rows.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'videos/Barbell_rows.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell squats',
        videoPath: 'videos/Barbell_squats.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Lateral raises ',
        videoPath: 'videos/Layeral_Raises.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'videos/shoulder_press.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Courtesy lunges',
        videoPath: 'videos/curtesy_lunges.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Sumo dead lift',
        videoPath: 'videos/sumo_deadlift.mp4',
        caloriesPerSet: 5,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
    ],
    'muscle_gain-beginner-outdoor':[
      Exercise(
        name: 'Incline push-ups',
        videoPath: 'videos/incline_pushups.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets of 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical Air-punches',
        videoPath: 'videos/vertical_air_punches.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Punch for 5 minutes to have effect',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      )
    ],
    'muscle_gain-intermediate-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'videos/45_degree_knee_to_elbow.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Arm to side',
        videoPath: 'videos/arm_to_side.mp4',
        caloriesPerSet: 2.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'videos/iron_crush.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'muscle_gain-advanced-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'videos/45_degree_knee_to_elbow.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'videos/iron_crush.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'videos/dumbbell_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Hamstring curl punch',
        videoPath: 'videos/hamstringcurl_puch.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'weight_loss-beginner-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'videos/45_degree_knee_to_elbow.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'videos/iron_crush.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'videos/dumbbell_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
      ),
    ],
    'weight_loss-intermediate-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'videos/45_degree_knee_to_elbow.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Courtesy lunges',
        videoPath: 'videos/curtesy_lunges.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'videos/dumbbell_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dips',
        videoPath: 'videos/Dips.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
      ),
    ],
    'weight_loss-advanced-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'videos/Tricep_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'videos/star_jump.mp4',
        caloriesPerMinute: 3,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'videos/iron_crush.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'videos/dumbbell_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dips',
        videoPath: 'videos/Dips.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Chairs'],
      ),
      Exercise(
        name: 'Dumbbell press extension',
        videoPath: 'videos/Dumbbell_press_extension.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Glute bridge',
        videoPath: 'videos/glute_bridge.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'weight_loss-beginner-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Horizontal punch',
        videoPath: 'videos/horizontal_punch.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hamstring curl punch',
        videoPath: 'videos/hamstringcurl_puch.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hyper extension',
        videoPath: 'videos/hyperextension.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['chair'],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dips',
        videoPath: 'videos/Dips.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Chairs'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
      ),
    ],
    'weight_loss-intermediate-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder squat',
        videoPath: 'videos/squat_shoulder.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Hamstring lunges',
        videoPath: 'videos/split_sqaut.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'videos/shoulder_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [''],
      ),
      Exercise(
        name: 'Seated back Shoulder',
        videoPath: 'videos/seatedback_shoulder.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm cable',
        videoPath: 'videos/oneorm_cable.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell forearm',
        videoPath: 'videos/dumbbell_forearm.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),

    ],
    'weight_loss-advanced-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell hip extension',
        videoPath: 'videos/dumbbell_hip_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Glute bridge',
        videoPath: 'videos/glute_bridge.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'videos/shoulder_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [''],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'videos/star_jump.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm cable',
        videoPath: 'videos/oneorm_cable.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Archer pushups',
        videoPath: 'videos/archer_pushups.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell Chestpress',
        videoPath: 'videos/barbell_chestpress.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'videos/Barbell_rows.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell burpees',
        videoPath: 'videos/dumbbell_burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'weight_loss-beginner-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree knee to elbow',
        videoPath: 'videos/45_degree_knee_to_elbow.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical air punches',
        videoPath: 'videos/vertical_air_punches.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell low windmill',
        videoPath: 'videos/dumbbell_low_windmill.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Burpees',
        videoPath: 'videos/Burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
    ],
    'weight_loss-intermediate-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'videos/Triceps_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical air punches',
        videoPath: 'videos/vertical_air_punches.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Dumbbell burpees',
        videoPath: 'videos/dumbbell_burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: ['Dumbbells'],
      ),
    ],
    'weight_loss-advanced-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerSet: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'videos/Triceps_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell overhead walk',
        videoPath: 'videos/dumbbell_overhead_walk.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'videos/jump_ropes.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Pull-up Bar'],
      ),
      Exercise(
        name: 'Laying abdominal crunches',
        videoPath: 'videos/lay_abdominal_crunches.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
    ],
    'maintenance-beginner-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell hip extension',
        videoPath: 'videos/dumbbell_hip_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Seated back shoulder',
        videoPath: 'videos/seatedback_shoulder.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'videos/jump_ropes.mp4',
        caloriesPerSet: 1.5,
        totalSets: 10,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'videos/knee_pull.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Push ups',
        videoPath: 'videos/pushups.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'maintenance-intermediate-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'videos/Triceps_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Vertical air punches',
        videoPath: 'videos/vertical_air_punches.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Dumbbell burpees',
        videoPath: 'videos/dumbbell_burpees.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
    ],
    'maintenance-advanced-gym':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Lateral raises',
        videoPath: 'videos/Layeral_Raises.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'One arm cable',
        videoPath: 'videos/oneorm_cable.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Shoulder press',
        videoPath: 'videos/shoulder_press.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Skull crushers',
        videoPath: 'videos/skull_crushers.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Split squat',
        videoPath: 'videos/split_sqaut.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Cable overhead extension',
        videoPath: 'videos/cable_overhead_extension.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),

    ],
    'maintenance-beginner-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'videos/jump_ropes.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'videos/Triceps_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: '45 degree side bend',
        videoPath: 'videos/45_degree_side_bend.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'maintenance-intermediate-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Squat shoulder',
        videoPath: 'videos/squat_shoulder.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 10,
        instructions: 'Perform for at least 10 minutes',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'videos/iron_crush.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Biceps curl',
        videoPath: 'videos/Biceps_curl.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Biceps_curl'],
      ),
    ],
    'maintenance-advanced-home':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name : 'Archer pushups',
        videoPath: 'videos/archer_pushups.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Barbell rows',
        videoPath: 'videos/Barbell_rows.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Barbell'],
      ),
      Exercise(
        name: 'Barbell squats',
        videoPath: 'videos/barbell_squats.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Barbell'],
      ),
      Exercise(
        name: 'Barbell clean press',
        videoPath: 'videos/Barbell_Clean_press.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: ['Barbell'],
      ),
    ],
    'maintenance-beginner-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Jump rope',
        videoPath: 'videos/jump_ropes.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: ['Ropes'],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'videos/knee_pull.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Push ups',
        videoPath: 'videos/pushups.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'maintenance-intermediate-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Triceps extension',
        videoPath: 'videos/Tricep_extension.mp4',
        caloriesPerSet: 3.5,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'videos/star_jump.mp4',
        caloriesPerSet: 3,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Iron crush',
        videoPath: 'videos/iron_crush.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Dumbbell press',
        videoPath: 'videos/dumbbell_press.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Pull ups',
        videoPath: 'videos/chin_up.mp4',
        caloriesPerSet: 10,
        totalSets: 10,
        instructions: '3 set for 10 reps',
        requiredEquipment: [],
      ),
    ],
    'maintenance-advanced-outdoor':[
      Exercise(
        name: 'Stretching',
        videoPath: 'videos/streatching.mp4',
        caloriesPerMinute: 1,
        durationInMinutes: 5,
        instructions: 'Stretch your body for at least 5 minutes',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Star jump',
        videoPath: 'videos/star_jump.mp4',
        caloriesPerSet: 1.5,
        totalSets: 30,
        instructions: '3 sets of 30 reps',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Courtesy lunges',
        videoPath: 'videos/curtesy_lunges.mp4',
        caloriesPerSet: 4,
        totalSets: 10,
        instructions: '3 sets for 10 reps',
        requiredEquipment: ['Dumbbells'],
      ),
      Exercise(
        name: 'Knee pull',
        videoPath: 'videos/knee_pull.mp4',
        caloriesPerMinute: 3.5,
        durationInMinutes: 10,
        instructions: '10 minutes of continuous workout',
        requiredEquipment: [],
      ),
      Exercise(
        name: 'Laying abdominal crunches',
        videoPath: 'videos/laying_abdominal_crunches.mp4',
        caloriesPerMinute: 3.5,
        durationInMinutes: 10,
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
    final userId = FirebaseAuth.instance.currentUser?.uid;

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
      body: Column(
        children: [
          if (userId != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: CalendarView(userId: userId),  // Calander View button
            ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return ExerciseCard(exercise: exercises[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Mark Today's Exercise as Completed"),
              onPressed: () async {
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User not logged in")),
                  );
                  return;
                }

                try {
                  await ExerciseTrackerService().logExercise(userId);
                  final streak = await ExerciseTrackerService().getCurrentStreak(userId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("🎉 Great job! You're on a $streak-day streak!"),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error logging exercise: $e"),
                    ),
                  );
                }
              },
            ),
          ),
        ],
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

  String _buildCaloriesText(Exercise exercise) {
    if (exercise.caloriesPerSet != null && exercise.totalSets != null) {
      final total = exercise.caloriesPerSet! * exercise.totalSets!;
      return 'Est. Calories: ${total.toStringAsFixed(1)} cal (Set-based)';
    } else if (exercise.caloriesPerMinute != null && exercise.durationInMinutes != null) {
      final total = exercise.caloriesPerMinute! * exercise.durationInMinutes!;
      return 'Est Calories: ${total.toStringAsFixed(1)} cal (Time-based)';
    } else {
      return 'Est. Calorie Not available';
    }
  }

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
            subtitle: Text(_buildCaloriesText(widget.exercise)),
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
class CalendarView extends StatefulWidget {
  final String userId;

  const CalendarView({super.key, required this.userId});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Map<DateTime, List<String>> _exerciseDays;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _currentStreak = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _exerciseDays = {};
    _loadExerciseData();
  }

  Future<void> _loadExerciseData() async {
    final history = await ExerciseTrackerService().getExerciseDates(widget.userId);
    final streak = await ExerciseTrackerService().getCurrentStreak(widget.userId);

    setState(() {
      _exerciseDays = {
        for (var date in history) _normalize(date): ['Workout done!']
      };
      _currentStreak = streak;
    });
  }

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<String> _getEventsForDay(DateTime day) {
    return _exerciseDays[_normalize(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: const Text("📅 View Exercise Calendar"),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (value) {
          setState(() => _isExpanded = value);
        },
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2100, 1, 1),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (_selectedDay != null &&
              _getEventsForDay(_selectedDay!).isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '✅ You worked out on ${_selectedDay!.toLocal().toString().split(" ")[0]}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "🔥 Current Streak: $_currentStreak days",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
