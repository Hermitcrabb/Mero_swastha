import 'package:flutter/material.dart';
import 'ExerciseQuestionDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ExercisePlanView.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  bool isLoading = true;
  bool hasExerciseProfile = false;
  Map<String, dynamic>? exerciseData;

  @override
  void initState() {
    super.initState();
    checkExerciseProfile();
  }

  Future<void> checkExerciseProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data?['exerciseProfile'] != null) {
      hasExerciseProfile = true;
      exerciseData = data!['exerciseProfile'];
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ExerciseQuestionDialog(uid: user.uid),
      );
      await checkExerciseProfile(); // recheck after submission
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Your Exercise Plan")),
      body: hasExerciseProfile
          ? ExercisePlanView(data: exerciseData!) // Custom widget to show plan
          : const Center(child: Text("No profile found.")),
    );
  }
}
