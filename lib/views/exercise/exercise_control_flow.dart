import 'package:flutter/material.dart';
import 'ExerciseQuestionDialog.dart';
import 'ExercisePlanView.dart';

class ExerciseFlowController extends StatefulWidget {
  final String uid;
  const ExerciseFlowController({super.key, required this.uid});

  @override
  State<ExerciseFlowController> createState() => _ExerciseFlowControllerState();
}

class _ExerciseFlowControllerState extends State<ExerciseFlowController> {
  Map<String, dynamic>? _exerciseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startExerciseFlow());
  }

  Future<void> _startExerciseFlow() async {
    try {
      while (mounted) {
        // Show configuration dialog
        final updatedData = await _showConfigurationDialog();
        if (updatedData == null) break; // User exited flow

        setState(() => _exerciseData = updatedData);

        // Show exercise plan
        await _showExercisePlan();

        // After returning from plan view, flow restarts automatically
      }
    } catch (e) {
      debugPrint('Exercise flow error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Map<String, dynamic>?> _showConfigurationDialog() async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExerciseQuestionDialog(
        uid: widget.uid,
        initialData: _exerciseData,
      ),
    );
  }

  Future<void> _showExercisePlan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExercisePlanView(data: _exerciseData!),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Planner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : const Center(child: Text('Setup your exercise plan')),
    );
  }
}