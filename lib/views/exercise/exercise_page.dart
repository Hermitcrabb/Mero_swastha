import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'ExerciseQuestionDialog.dart';
import 'ExercisePlanView.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _hasExerciseProfile = false;
  Map<String, dynamic>? _exerciseData;

  @override
  void initState() {
    super.initState();
    _loadExerciseProfile();
  }

  Future<void> _loadExerciseProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _handleNoUser();
        return;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      await _processProfileData(doc);
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _processProfileData(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>?; //Explicit type casting
    if (data == null || data['exerciseProfile'] == null) {
      await _showProfileDialog();
      await _loadExerciseProfile(); // Reload after submission
    } else {
      setState(() {
        _exerciseData = data['exerciseProfile'] as Map<String, dynamic>; // Type casting
        _hasExerciseProfile = true;
      });
    }
  }

  Future<void> _showProfileDialog() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExerciseQuestionDialog(
        uid: user.uid,
        initialData: _exerciseData,
      ),
    );

    if (result != null) {
      //Update local state with new data
      setState(() {
        _exerciseData = result;
        _hasExerciseProfile = true;
      });
      //Update Firestore with new data
      await _updateFirestoreProfile(user.uid, result);

      //Reload to reflect changes
      await _loadExerciseProfile();
    }
  }
  Future<void> _updateFirestoreProfile(String uid, Map<String, dynamic> newData) async {
  try{
    await _firestore.collection('users').doc(uid).update({
      'exerciseProfile': newData,
      'lastUpdated' : FieldValue.serverTimestamp(),
    });
  }catch(e){
    Get.snackbar(
      "Error",
      "Failed to update profile",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      );
   }
  }

  void _handleNoUser() {
    Get.snackbar(
      'Authentication Required',
      'Please sign in to access exercise features',
      snackPosition: SnackPosition.BOTTOM,
    );
    setState(() => _isLoading = false);
  }

  void _handleError(dynamic error) {
    Get.snackbar(
      'Error',
      'Failed to load exercise profile: ${error.toString()}',
      snackPosition: SnackPosition.BOTTOM,
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Exercise Plan'),
        actions: [
          if (_hasExerciseProfile)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _showProfileDialog,
              tooltip: 'Edit Plan',
            ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasExerciseProfile) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No exercise profile found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExerciseProfile,
              child: const Text('Create Exercise Plan'),
            ),
          ],
        ),
      );
    }

    return ExercisePlanView(data: _exerciseData!);
  }
}